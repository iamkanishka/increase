defmodule Increase.Client do
  @moduledoc """
  The low-level HTTP client used by every resource module to talk to the
  Increase API. You normally don't need to use this module directly --
  resource modules like `Increase.Accounts` build the right client for you
  from configuration -- but it's available if you want full control over
  how requests are made.

  ## Configuration

  A `%Increase.Client{}` struct holds everything needed to make a request:
  the API key, the base URL (sandbox or production), and any default Req
  options you want applied to every request (timeouts, retry policy,
  custom middleware, etc).

  By default, configuration is read from your application config:

      config :increase,
        api_key: System.fetch_env!("INCREASE_API_KEY"),
        environment: :sandbox # or :production

  You can also build a client explicitly and pass it to any resource
  function as the last argument:

      client = Increase.Client.new(api_key: "sandbox_...", environment: :sandbox)
      {:ok, account} = Increase.Accounts.retrieve(client, "account_123")

  ## Retries

  Requests are retried automatically on rate limiting (HTTP 429), server
  errors (500/502/503/504), and transient transport failures (timeouts,
  connection refused), with exponential backoff honoring the API's
  `Retry-After` header when present. This applies to every HTTP method,
  including `POST`/`PATCH` -- safe to do because, whenever retries are
  enabled, this client automatically attaches an idempotency key to every
  mutating request that doesn't already have one, generated once before
  the first attempt and reused for every retry of that same request.
  Increase guarantees retrying a request with the same Idempotency-Key
  returns the original result rather than creating a duplicate object,
  so this can never double-create anything.

  Retry behavior is just Req's own `:retry` option (see `Req.Steps.retry/1`
  for full details) and can be reconfigured or disabled per-client:

      # Disable retries entirely:
      Increase.Client.new(retry: false)

      # Cap at 1 retry instead of the default:
      Increase.Client.new(max_retries: 1)

  ## Telemetry

  Every request emits `:telemetry` events under the `[:increase, :request]`
  prefix:

    * `[:increase, :request, :start]` -- before a request is sent.
      Measurements: `:system_time`. Metadata: `:method`, `:path`.
    * `[:increase, :request, :stop]` -- after a response (success or API
      error) is received. Measurements: `:duration` (native time units).
      Metadata: `:method`, `:path`, and either `:status` (on success or
      an API-level error) or `:error` (on a transport-level failure).
    * `[:increase, :request, :exception]` -- if the request raises
      instead of returning. Metadata includes `:kind`, `:reason`, and
      `:stacktrace`.

  Attach a handler with `:telemetry.attach/4` or `:telemetry.attach_many/4`
  to log, trace, or collect metrics on outgoing requests:

      :telemetry.attach(
        "log-increase-requests",
        [:increase, :request, :stop],
        fn _event, measurements, metadata, _config ->
          duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
          Logger.info("Increase \#{metadata.method} \#{metadata.path} -> \#{metadata[:status]} in \#{duration_ms}ms")
        end,
        nil
      )
  """

  defstruct api_key: nil,
            base_url: nil,
            req_options: []

  @type t :: %__MODULE__{
          api_key: String.t() | nil,
          base_url: String.t(),
          req_options: keyword()
        }

  @sandbox_url "https://sandbox.increase.com"
  @production_url "https://api.increase.com"

  @doc """
  Builds a new client.

  ## Options

    * `:api_key` - your Increase API key. Defaults to the `:api_key` value
      configured under `config :increase, ...`, or the `INCREASE_API_KEY`
      environment variable.
    * `:environment` - either `:sandbox` or `:production`. Defaults to the
      configured `:environment`, or `:sandbox` if nothing is configured.
    * `:base_url` - override the base URL entirely (useful for testing
      against a local mock server). Takes precedence over `:environment`.
    * any other option is passed straight through to `Req.new/1` for every
      request made with this client (e.g. `:receive_timeout`, `:retry`,
      `:plug`). See the "Retries" section above for retry-specific options.
  """
  @spec new(keyword()) :: t()
  def new(opts \\ []) do
    api_key =
      Keyword.get(opts, :api_key) ||
        Application.get_env(:increase, :api_key) ||
        System.get_env("INCREASE_API_KEY")

    base_url =
      Keyword.get(opts, :base_url) ||
        case Keyword.get(opts, :environment) ||
               Application.get_env(:increase, :environment, :sandbox) do
          :production -> @production_url
          :sandbox -> @sandbox_url
          other when is_binary(other) -> other
        end

    req_options =
      opts
      |> Keyword.drop([:api_key, :environment, :base_url])
      |> Keyword.put_new(:retry, &default_retry?/2)

    %__MODULE__{api_key: api_key, base_url: base_url, req_options: req_options}
  end

  @doc false
  @spec default() :: t()
  def default, do: new()

  @doc """
  Resolves a client argument that may already be a `%Increase.Client{}`,
  a keyword list of options, or `nil` (in which case the default client
  built from application config is used). Every resource function accepts
  any of these forms for its trailing `client` argument.
  """
  @spec resolve(t() | keyword() | nil) :: t()
  def resolve(%__MODULE__{} = client), do: client
  def resolve(nil), do: default()
  def resolve(opts) when is_list(opts), do: new(opts)

  @doc false
  @spec request(t(), atom(), String.t(), keyword()) ::
          {:ok, term()} | {:error, Increase.Error.t()}
  def request(%__MODULE__{} = client, method, path, opts \\ []) do
    query = Keyword.get(opts, :query, %{})
    body = Keyword.get(opts, :body)
    idempotency_key = idempotency_key_for(client, method, opts)

    headers =
      [{"authorization", "Bearer #{client.api_key}"}]
      |> maybe_add_idempotency_header(idempotency_key)

    req_opts =
      [
        method: method,
        url: client.base_url <> "/" <> String.trim_leading(path, "/"),
        headers: headers,
        params: encode_query(query)
      ]
      |> maybe_put_json(body)
      |> Keyword.merge(client.req_options)

    :telemetry.span(
      [:increase, :request],
      %{method: method, path: path},
      fn ->
        result =
          req_opts
          |> Req.new()
          |> Req.request()
          |> handle_response()

        stop_metadata =
          case result do
            {:ok, _} ->
              %{method: method, path: path}

            {:error, %Increase.Error{status: status}} when not is_nil(status) ->
              %{method: method, path: path, status: status}

            {:error, error} ->
              %{method: method, path: path, error: error}
          end

        {result, stop_metadata}
      end
    )
  end

  # Retries are only meaningfully safe for mutating requests if an
  # idempotency key is guaranteed present on every attempt -- so this
  # generates one up front (once, before the first attempt) whenever
  # retries are enabled and the caller didn't already supply one.
  # GET/DELETE requests don't need one (idempotent by nature), and if
  # retries are disabled there's no replay risk to protect against.
  defp idempotency_key_for(client, method, opts) do
    case Keyword.get(opts, :idempotency_key) do
      nil ->
        if method in [:post, :patch] and retries_enabled?(client) do
          generate_idempotency_key()
        end

      key ->
        key
    end
  end

  defp retries_enabled?(client) do
    case Keyword.get(client.req_options, :retry, &default_retry?/2) do
      false -> false
      _ -> true
    end
  end

  @doc false
  # A UUID v4, generated without any extra dependency. Used as the
  # auto-generated Idempotency-Key for retried mutating requests.
  @spec generate_idempotency_key() :: String.t()
  def generate_idempotency_key do
    <<u0::48, _::4, u1::12, _::2, u2::62>> = :crypto.strong_rand_bytes(16)

    Base.encode16(<<u0::48, 4::4, u1::12, 2::2, u2::62>>, case: :lower)
    |> insert_uuid_dashes()
  end

  defp insert_uuid_dashes(<<a::binary-8, b::binary-4, c::binary-4, d::binary-4, e::binary-12>>) do
    "#{a}-#{b}-#{c}-#{d}-#{e}"
  end

  # Default retry policy: retry on rate limiting, server errors, and
  # transient transport failures, for every HTTP method. Safe for
  # mutating requests specifically because idempotency_key_for/3 above
  # guarantees an Idempotency-Key is attached before the first attempt
  # whenever this function is in effect.
  @doc false
  @spec default_retry?(Req.Request.t(), Req.Response.t() | Exception.t()) :: boolean()
  def default_retry?(_request, %Req.Response{status: status}) do
    status in [408, 429, 500, 502, 503, 504]
  end

  def default_retry?(_request, %Req.TransportError{reason: reason}) do
    reason in [:timeout, :econnrefused, :closed]
  end

  def default_retry?(_request, _response_or_exception), do: false

  defp maybe_add_idempotency_header(headers, nil), do: headers

  defp maybe_add_idempotency_header(headers, key),
    do: [{"idempotency-key", key} | headers]

  defp maybe_put_json(req_opts, nil), do: req_opts
  defp maybe_put_json(req_opts, body), do: Keyword.put(req_opts, :json, body)

  # Increase expects nested filter params joined with `.`, e.g.
  # created_at.before=...&created_at.after=.... We flatten any nested map
  # in the query into that dotted form. Arrays (like status.in) are passed
  # through as comma-joined strings, per the docs.
  @doc false
  def encode_query(query) when is_map(query) or is_list(query) do
    query
    |> Enum.flat_map(&flatten_query_pair/1)
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
  end

  defp flatten_query_pair({key, value}) when is_map(value) do
    Enum.flat_map(value, fn {sub_key, sub_value} ->
      flatten_query_pair({"#{key}.#{sub_key}", sub_value})
    end)
  end

  defp flatten_query_pair({key, value}) when is_list(value) do
    [{to_string(key), Enum.join(Enum.map(value, &to_string/1), ",")}]
  end

  defp flatten_query_pair({key, value}), do: [{to_string(key), value}]

  defp handle_response({:ok, %Req.Response{status: status, body: body}})
       when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}) do
    {:error, Increase.Error.from_response(status, body)}
  end

  defp handle_response({:error, exception}) do
    {:error, Increase.Error.from_exception(exception)}
  end
end
