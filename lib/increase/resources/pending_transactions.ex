defmodule Increase.PendingTransactions do
  @moduledoc """
  Pending Transactions are potential future additions and removals of money from
  your bank account. They impact your available balance, but not your current
  balance. To learn more, see
  [Transactions and Transfers].

  See https://increase.com/documentation/api/pending-transactions for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule PendingTransaction do
    @moduledoc """
    Pending Transactions are potential future additions and removals of money
    from your bank account. They impact your available balance, but not your
    current balance. To learn more, see [Transactions and
    Transfers].

    ## Fields

      * `id` - The Pending Transaction identifier.
      * `account_id` - The identifier for the account this Pending Transaction belongs to.
      * `amount` - The Pending Transaction amount in the minor unit of its currency. For
        dollars, for example, this is cents.
      * `completed_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date on which
        the Pending Transaction was completed.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date on which the
        Pending Transaction occurred.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the Pending
        Transaction's currency. This will match the currency on the Pending
        Transaction's Account.
      * `description` - For a Pending Transaction related to a transfer, this is the description
        you provide. For a Pending Transaction related to a payment, this is the
        description the vendor provides.
      * `held_amount` - The amount that this Pending Transaction decrements the available
        balance of its Account. This is usually the same as `amount`, but will
        differ if the amount is positive.
      * `route_id` - The identifier for the route this Pending Transaction came through. Routes
        are things like cards and ACH details.
      * `route_type` - The type of the route this Pending Transaction came through.
      * `source` - This is an object giving more details on the network-level event that caused
        the Pending Transaction. For example, for a card transaction this lists the
        merchant's industry and location.
        A map keyed by `"category"`. Exactly one of the
        following keys is present, matching that discriminator's value:

          * `"account_transfer_instruction"`
          * `"ach_transfer_instruction"`
          * `"blockchain_offramp_transfer"`
          * `"blockchain_onramp_transfer_instruction"`
          * `"card_authorization"`
          * `"card_push_transfer_instruction"`
          * `"check_deposit_instruction"`
          * `"check_transfer_instruction"`
          * `"fednow_transfer_instruction"`
          * `"inbound_funds_hold"`
          * `"inbound_wire_transfer_reversal"`
          * `"other"`
          * `"real_time_payments_transfer_instruction"`
          * `"swift_transfer_instruction"`
          * `"wire_transfer_instruction"`
      * `status` - Whether the Pending Transaction has been confirmed and has an associated
        Transaction.
      * `type` - A constant representing the object's type. For this resource it will always be
        `pending_transaction`.
    """

    defstruct [
      :id,
      :account_id,
      :amount,
      :completed_at,
      :created_at,
      :currency,
      :description,
      :held_amount,
      :route_id,
      :route_type,
      :source,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            amount: integer(),
            completed_at: DateTime.t() | nil,
            created_at: DateTime.t(),
            currency: String.t(),
            description: String.t(),
            held_amount: integer(),
            route_id: String.t() | nil,
            route_type: String.t() | nil,
            source: map(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        amount: raw["amount"],
        completed_at: Increase.Decode.datetime(raw["completed_at"]),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        currency: raw["currency"],
        description: raw["description"],
        held_amount: raw["held_amount"],
        route_id: raw["route_id"],
        route_type: raw["route_type"],
        source: raw["source"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Creates a pending transaction on an account. This can be useful to hold
  funds for an external payment or known future transaction outside of
  Increase (only negative amounts are supported). The resulting Pending
  Transaction will have a `category` of `user_initiated_hold` and can be
  released via the API to unlock the held funds.

  `POST /pending_transactions`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, PendingTransaction.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/pending_transactions"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, PendingTransaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Pending Transaction

  `GET /pending_transactions/{pending_transaction_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, PendingTransaction.t()} | {:error, Increase.Error.t()}
  def retrieve(client, pending_transaction_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/pending_transactions/#{pending_transaction_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, PendingTransaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Pending Transactions

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  PendingTransaction{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /pending_transactions`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/pending_transactions"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &PendingTransaction.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Release a Pending Transaction you had previously created. The Pending
  Transaction must have a `category` of `user_initiated_hold` and a `status`
  of `pending`. This will unlock the held funds and mark the Pending
  Transaction as complete.

  `POST /pending_transactions/{pending_transaction_id}/release`
  """
  @spec release(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, PendingTransaction.t()} | {:error, Increase.Error.t()}
  def release(client, pending_transaction_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/pending_transactions/#{pending_transaction_id}/release"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, PendingTransaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
