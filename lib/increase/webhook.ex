defmodule Increase.Webhook do
  @moduledoc """
  Verifies the authenticity of incoming webhook requests from Increase.

  Increase signs every webhook using the [Standard
  Webhooks](https://www.standardwebhooks.com/) specification: each request
  carries `webhook-id`, `webhook-timestamp`, and `webhook-signature`
  headers, and the signature is an HMAC-SHA256 of `"\#{id}.\#{timestamp}.\#{raw_body}"`
  using your endpoint's signing secret, Base64-encoded and prefixed with
  `v1,`. See https://increase.com/documentation/webhooks#securing-your-webhook-endpoint
  for the full specification.

  You can find your endpoint's signing secret in the
  [dashboard](https://dashboard.increase.com/developers/webhooks), on the
  Event Subscription you created.

  ## Usage

  Verify a webhook as early as possible in your endpoint, using the
  **raw, unparsed** request body -- not a body that's already been
  decoded into a map, since the signature is computed over the exact
  bytes Increase sent:

      def webhook_controller_action(conn, _params) do
        {:ok, raw_body, conn} = Plug.Conn.read_body(conn)

        headers = %{
          "webhook-id" => List.first(Plug.Conn.get_req_header(conn, "webhook-id")),
          "webhook-timestamp" => List.first(Plug.Conn.get_req_header(conn, "webhook-timestamp")),
          "webhook-signature" => List.first(Plug.Conn.get_req_header(conn, "webhook-signature"))
        }

        case Increase.Webhook.verify(raw_body, headers, signing_secret()) do
          :ok ->
            event = Jason.decode!(raw_body)
            handle_event(event)
            Plug.Conn.send_resp(conn, 200, "")

          {:error, reason} ->
            Plug.Conn.send_resp(conn, 400, "invalid signature: \#{reason}")
        end
      end

  `verify/3` returns `:ok` or `{:error, reason}` rather than raising, since
  an invalid signature is an expected outcome (anyone can hit your
  endpoint) rather than a programming error.
  """

  @default_tolerance_seconds 300

  @doc """
  Verifies a webhook request's signature and timestamp.

  ## Arguments

    * `raw_body` - the exact, raw request body bytes Increase sent, as a
      string. Must not be re-encoded JSON or otherwise modified -- the
      signature covers the literal bytes received.
    * `headers` - a map (or anything with `Access` behaviour, like a
      `Plug.Conn`'s header list converted to a map) containing the
      `"webhook-id"`, `"webhook-timestamp"`, and `"webhook-signature"`
      header values as strings. Header name lookups are case-sensitive;
      lowercase them yourself first if your web framework preserves
      original casing.
    * `signing_secret` - your Event Subscription's signing secret, from
      the Increase dashboard.

  ## Options

    * `:tolerance` - the maximum allowed age (in seconds, either
      direction) between `webhook-timestamp` and now, to protect against
      replay attacks. Defaults to 300 (5 minutes), matching Increase's
      own recommendation. Pass `false` to disable timestamp checking
      entirely (not recommended).

  ## Examples

      iex> Increase.Webhook.verify(raw_body, headers, secret)
      :ok

      iex> Increase.Webhook.verify(tampered_body, headers, secret)
      {:error, :signature_mismatch}
  """
  @spec verify(String.t(), map(), String.t(), keyword()) ::
          :ok
          | {:error,
             :missing_headers
             | :invalid_timestamp
             | :timestamp_out_of_tolerance
             | :signature_mismatch}
  def verify(raw_body, headers, signing_secret, opts \\ [])
      when is_binary(raw_body) and is_binary(signing_secret) do
    with {:ok, id, timestamp, signature_header} <- fetch_headers(headers),
         :ok <-
           check_tolerance(timestamp, Keyword.get(opts, :tolerance, @default_tolerance_seconds)),
         :ok <- check_signature(id, timestamp, raw_body, signature_header, signing_secret) do
      :ok
    end
  end

  defp fetch_headers(headers) do
    id = Map.get(headers, "webhook-id")
    timestamp = Map.get(headers, "webhook-timestamp")
    signature = Map.get(headers, "webhook-signature")

    if is_binary(id) and is_binary(timestamp) and is_binary(signature) do
      {:ok, id, timestamp, signature}
    else
      {:error, :missing_headers}
    end
  end

  defp check_tolerance(_timestamp, false), do: :ok

  defp check_tolerance(timestamp, tolerance_seconds) do
    case Integer.parse(timestamp) do
      {timestamp_int, ""} ->
        now = System.system_time(:second)

        if abs(now - timestamp_int) <= tolerance_seconds do
          :ok
        else
          {:error, :timestamp_out_of_tolerance}
        end

      _ ->
        {:error, :invalid_timestamp}
    end
  end

  defp check_signature(id, timestamp, raw_body, signature_header, signing_secret) do
    expected = compute_signature(id, timestamp, raw_body, signing_secret)

    received_signatures =
      signature_header
      |> String.split(" ", trim: true)

    if Enum.any?(received_signatures, &constant_time_equal?(&1, expected)) do
      :ok
    else
      {:error, :signature_mismatch}
    end
  end

  @doc """
  Computes the expected `v1,<base64>` signature for a webhook payload, the
  same way Increase does. Exposed mainly for testing your own webhook
  handler against fixtures; `verify/4` is what you want for actually
  verifying incoming requests.
  """
  @spec compute_signature(String.t(), String.t(), String.t(), String.t()) :: String.t()
  def compute_signature(id, timestamp, raw_body, signing_secret) do
    signed_payload = "#{id}.#{timestamp}.#{raw_body}"
    mac = :crypto.mac(:hmac, :sha256, signing_secret, signed_payload)
    "v1," <> Base.encode64(mac)
  end

  defp constant_time_equal?(a, b)
       when is_binary(a) and is_binary(b) and byte_size(a) == byte_size(b) do
    a
    |> :erlang.binary_to_list()
    |> Enum.zip(:erlang.binary_to_list(b))
    |> Enum.reduce(0, fn {x, y}, acc -> Bitwise.bor(acc, Bitwise.bxor(x, y)) end)
    |> Kernel.==(0)
  end

  defp constant_time_equal?(_a, _b), do: false
end
