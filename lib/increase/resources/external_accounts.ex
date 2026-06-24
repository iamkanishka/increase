defmodule Increase.ExternalAccounts do
  @moduledoc """
  External Accounts represent accounts at financial institutions other than
  Increase. You can use this API to store their details for reuse.

  See https://increase.com/documentation/api/external-accounts for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule ExternalAccount do
    @moduledoc """
    External Accounts represent accounts at financial institutions other than
    Increase. You can use this API to store their details for reuse.

    ## Fields

      * `id` - The External Account's identifier.
      * `account_holder` - The type of entity that owns the External Account.
      * `account_number` - The destination account number.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the External Account was created.
      * `description` - The External Account's description for display purposes.
      * `funding` - The type of the account to which the transfer will be sent.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `routing_number` - The American Bankers' Association (ABA) Routing Transit Number (RTN).
      * `status` - The External Account's status.
      * `type` - A constant representing the object's type. For this resource it will always be
        `external_account`.
    """

    defstruct [
      :id,
      :account_holder,
      :account_number,
      :created_at,
      :description,
      :funding,
      :idempotency_key,
      :routing_number,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_holder: String.t(),
            account_number: String.t(),
            created_at: DateTime.t(),
            description: String.t(),
            funding: String.t(),
            idempotency_key: String.t() | nil,
            routing_number: String.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_holder: raw["account_holder"],
        account_number: raw["account_number"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        description: raw["description"],
        funding: raw["funding"],
        idempotency_key: raw["idempotency_key"],
        routing_number: raw["routing_number"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an External Account

  `POST /external_accounts`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, ExternalAccount.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/external_accounts"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, ExternalAccount.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an External Account

  `GET /external_accounts/{external_account_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, ExternalAccount.t()} | {:error, Increase.Error.t()}
  def retrieve(client, external_account_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/external_accounts/#{external_account_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, ExternalAccount.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update an External Account

  `PATCH /external_accounts/{external_account_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, ExternalAccount.t()} | {:error, Increase.Error.t()}
  def update(client, external_account_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/external_accounts/#{external_account_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, ExternalAccount.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List External Accounts

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  ExternalAccount{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /external_accounts`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/external_accounts"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &ExternalAccount.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
