defmodule Increase.IntrafiExclusions do
  @moduledoc """
  Certain institutions may be excluded per Entity when sweeping funds into the
  IntraFi network. This is useful when an Entity already has deposits at a
  particular bank, and does not want to sweep additional funds to it. It may take
  5 business days for an exclusion to be processed.

  See https://increase.com/documentation/api/intrafi-exclusions for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule IntrafiExclusion do
    @moduledoc """
    Certain institutions may be excluded per Entity when sweeping funds into the
    IntraFi network. This is useful when an Entity already has deposits at a
    particular bank, and does not want to sweep additional funds to it. It may
    take 5 business days for an exclusion to be processed.

    ## Fields

      * `id` - The identifier of this exclusion request.
      * `bank_name` - The name of the excluded institution.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the exclusion was created.
      * `entity_id` - The entity for which this institution is excluded.
      * `excluded_at` - When this was exclusion was confirmed by IntraFi.
      * `fdic_certificate_number` - The Federal Deposit Insurance Corporation's certificate
        number for the institution.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `status` - The status of the exclusion request.
      * `submitted_at` - When this was exclusion was submitted to IntraFi by Increase.
      * `type` - A constant representing the object's type. For this resource it will always be
        `intrafi_exclusion`.
    """

    defstruct [
      :id,
      :bank_name,
      :created_at,
      :entity_id,
      :excluded_at,
      :fdic_certificate_number,
      :idempotency_key,
      :status,
      :submitted_at,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            bank_name: String.t() | nil,
            created_at: DateTime.t(),
            entity_id: String.t(),
            excluded_at: DateTime.t() | nil,
            fdic_certificate_number: String.t() | nil,
            idempotency_key: String.t() | nil,
            status: String.t(),
            submitted_at: DateTime.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        bank_name: raw["bank_name"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        entity_id: raw["entity_id"],
        excluded_at: Increase.Decode.datetime(raw["excluded_at"]),
        fdic_certificate_number: raw["fdic_certificate_number"],
        idempotency_key: raw["idempotency_key"],
        status: raw["status"],
        submitted_at: Increase.Decode.datetime(raw["submitted_at"]),
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an IntraFi Exclusion

  `POST /intrafi_exclusions`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, IntrafiExclusion.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_exclusions"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, IntrafiExclusion.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Get an IntraFi Exclusion

  `GET /intrafi_exclusions/{intrafi_exclusion_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, IntrafiExclusion.t()} | {:error, Increase.Error.t()}
  def retrieve(client, intrafi_exclusion_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_exclusions/#{intrafi_exclusion_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, IntrafiExclusion.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List IntraFi Exclusions

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  IntrafiExclusion{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /intrafi_exclusions`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_exclusions"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &IntrafiExclusion.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Archive an IntraFi Exclusion

  `POST /intrafi_exclusions/{intrafi_exclusion_id}/archive`
  """
  @spec archive(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, IntrafiExclusion.t()} | {:error, Increase.Error.t()}
  def archive(client, intrafi_exclusion_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_exclusions/#{intrafi_exclusion_id}/archive"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, IntrafiExclusion.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
