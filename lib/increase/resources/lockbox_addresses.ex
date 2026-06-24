defmodule Increase.LockboxAddresses do
  @moduledoc """
  Lockbox Addresses are physical locations that can receive mail containing paper
  checks.

  See https://increase.com/documentation/api/lockbox-addresses for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule LockboxAddress do
    @moduledoc """
    Lockbox Addresses are physical locations that can receive mail containing
    paper checks.

    ## Fields

      * `id` - The Lockbox Address identifier.
      * `address` - The mailing address for the Lockbox Address. It will be present after
        Increase generates it.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Lockbox Address was created.
      * `description` - The description you choose for the Lockbox Address.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `status` - The status of the Lockbox Address.
      * `type` - A constant representing the object's type. For this resource it will always be
        `lockbox_address`.
    """

    defmodule Address do
      @moduledoc """
      The mailing address for the Lockbox Address. It will be present after
      Increase generates it.

      ## Fields

        * `city` - The city of the address.
        * `line1` - The first line of the address.
        * `line2` - The second line of the address.
        * `postal_code` - The postal code of the address.
        * `state` - The two-letter United States Postal Service (USPS) abbreviation for the
          state of the address.
      """

      defstruct [:city, :line1, :line2, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t(),
              line1: String.t(),
              line2: String.t(),
              postal_code: String.t(),
              state: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          line1: raw["line1"],
          line2: raw["line2"],
          postal_code: raw["postal_code"],
          state: raw["state"]
        }
      end
    end

    defstruct [:id, :address, :created_at, :description, :idempotency_key, :status, :type]

    @type t :: %__MODULE__{
            id: String.t(),
            address: Address.t() | nil,
            created_at: DateTime.t(),
            description: String.t() | nil,
            idempotency_key: String.t() | nil,
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        address: Increase.Decode.struct(raw["address"], &Address.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        description: raw["description"],
        idempotency_key: raw["idempotency_key"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Lockbox Address

  `POST /lockbox_addresses`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, LockboxAddress.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_addresses"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, LockboxAddress.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Lockbox Address

  `GET /lockbox_addresses/{lockbox_address_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, LockboxAddress.t()} | {:error, Increase.Error.t()}
  def retrieve(client, lockbox_address_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_addresses/#{lockbox_address_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, LockboxAddress.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update a Lockbox Address

  `PATCH /lockbox_addresses/{lockbox_address_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, LockboxAddress.t()} | {:error, Increase.Error.t()}
  def update(client, lockbox_address_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_addresses/#{lockbox_address_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, LockboxAddress.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Lockbox Addresses

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  LockboxAddress{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /lockbox_addresses`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_addresses"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &LockboxAddress.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
