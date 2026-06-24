defmodule Increase.Transactions do
  @moduledoc """
  Transactions are the immutable additions and removals of money from your bank
  account. They're the equivalent of line items on your bank statement. To learn
  more, see [Transactions and Transfers]

  See https://increase.com/documentation/api/transactions for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule Transaction do
    @moduledoc """
    Transactions are the immutable additions and removals of money from your
    bank account. They're the equivalent of line items on your bank statement.
    To learn more, see [Transactions and
    Transfers].

    ## Fields

      * `id` - The Transaction identifier.
      * `account_id` - The identifier for the Account the Transaction belongs to.
      * `amount` - The Transaction amount in the minor unit of its currency. For dollars, for
        example, this is cents.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Transaction occurred.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
        Transaction's currency. This will match the currency on the Transaction's
        Account.
      * `description` - An informational message describing this transaction. Use the fields in
        `source` to get more detailed information. This field appears as the
        line-item on the statement.
      * `route_id` - The identifier for the route this Transaction came through. Routes are
        things like cards and ACH details.
      * `route_type` - The type of the route this Transaction came through.
      * `source` - This is an object giving more details on the network-level event that caused
        the Transaction. Note that for backwards compatibility reasons, additional
        undocumented keys may appear in this object. These should be treated as
        deprecated and will be removed in the future.
        A map keyed by `"category"`. Exactly one of the
        following keys is present, matching that discriminator's value:

          * `"account_revenue_payment"`
          * `"account_transfer_intention"`
          * `"ach_transfer_intention"`
          * `"ach_transfer_rejection"`
          * `"ach_transfer_return"`
          * `"blockchain_offramp_transfer_settlement"`
          * `"blockchain_onramp_transfer_intention"`
          * `"card_dispute_acceptance"`
          * `"card_dispute_financial"`
          * `"card_dispute_loss"`
          * `"card_financial"`
          * `"card_push_transfer_acceptance"`
          * `"card_refund"`
          * `"card_revenue_payment"`
          * `"card_settlement"`
          * `"cashback_payment"`
          * `"check_deposit_acceptance"`
          * `"check_deposit_return"`
          * `"check_transfer_deposit"`
          * `"fednow_transfer_acknowledgement"`
          * `"fee_payment"`
          * `"inbound_ach_transfer"`
          * `"inbound_ach_transfer_return_intention"`
          * `"inbound_check_adjustment"`
          * `"inbound_check_deposit_return_intention"`
          * `"inbound_fednow_transfer_confirmation"`
          * `"inbound_real_time_payments_transfer_confirmation"`
          * `"inbound_wire_reversal"`
          * `"inbound_wire_transfer"`
          * `"inbound_wire_transfer_reversal"`
          * `"interest_payment"`
          * `"internal_source"`
          * `"other"`
          * `"real_time_payments_transfer_acknowledgement"`
          * `"sample_funds"`
          * `"swift_transfer_intention"`
          * `"swift_transfer_return"`
          * `"wire_transfer_intention"`
      * `type` - A constant representing the object's type. For this resource it will always be
        `transaction`.
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
  Retrieve a Transaction

  `GET /transactions/{transaction_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Transaction.t()} | {:error, Increase.Error.t()}
  def retrieve(client, transaction_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/transactions/#{transaction_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Transaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Transactions

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  Transaction{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /transactions`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/transactions"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &Transaction.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
