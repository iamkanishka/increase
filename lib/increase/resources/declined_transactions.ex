defmodule Increase.DeclinedTransactions do
  @moduledoc """
  Declined Transactions are refused additions and removals of money from your bank
  account. For example, Declined Transactions are caused when your Account has an
  insufficient balance or your Limits are triggered.

  See https://increase.com/documentation/api/declined-transactions for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule DeclinedTransaction do
    @moduledoc """
    Declined Transactions are refused additions and removals of money from your
    bank account. For example, Declined Transactions are caused when your
    Account has an insufficient balance or your Limits are triggered.

    ## Fields

      * `id` - The Declined Transaction identifier.
      * `account_id` - The identifier for the Account the Declined Transaction belongs to.
      * `amount` - The Declined Transaction amount in the minor unit of its currency. For
        dollars, for example, this is cents.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date on which the
        Transaction occurred.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
        Declined Transaction's currency. This will match the currency on the
        Declined Transaction's Account.
      * `description` - This is the description the vendor provides.
      * `route_id` - The identifier for the route this Declined Transaction came through. Routes
        are things like cards and ACH details.
      * `route_type` - The type of the route this Declined Transaction came through.
      * `source` - This is an object giving more details on the network-level event that caused
        the Declined Transaction. For example, for a card transaction this lists the
        merchant's industry and location. Note that for backwards compatibility
        reasons, additional undocumented keys may appear in this object. These should
        be treated as deprecated and will be removed in the future.
        A map keyed by `"category"`. Exactly one of the
        following keys is present, matching that discriminator's value:

          * `"ach_decline"`
          * `"card_decline"`
          * `"check_decline"`
          * `"check_deposit_rejection"`
          * `"inbound_fednow_transfer_decline"`
          * `"inbound_real_time_payments_transfer_decline"`
          * `"other"`
          * `"wire_decline"`
      * `type` - A constant representing the object's type. For this resource it will always be
        `declined_transaction`.
    """

    defstruct [
      :id,
      :account_id,
      :amount,
      :created_at,
      :currency,
      :description,
      :route_id,
      :route_type,
      :source,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            amount: integer(),
            created_at: DateTime.t(),
            currency: String.t(),
            description: String.t(),
            route_id: String.t() | nil,
            route_type: String.t() | nil,
            source: map(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        amount: raw["amount"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        currency: raw["currency"],
        description: raw["description"],
        route_id: raw["route_id"],
        route_type: raw["route_type"],
        source: raw["source"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve a Declined Transaction

  `GET /declined_transactions/{declined_transaction_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, DeclinedTransaction.t()} | {:error, Increase.Error.t()}
  def retrieve(client, declined_transaction_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/declined_transactions/#{declined_transaction_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, DeclinedTransaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Declined Transactions

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  DeclinedTransaction{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /declined_transactions`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/declined_transactions"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &DeclinedTransaction.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
