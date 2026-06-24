defmodule Increase.InboundRealTimePaymentsTransfers do
  @moduledoc """
  An Inbound Real-Time Payments Transfer is a Real-Time Payments transfer
  initiated outside of Increase to your account.

  See https://increase.com/documentation/api/inbound-real-time-payments-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule InboundRealTimePaymentsTransfer do
    @moduledoc """
    An Inbound Real-Time Payments Transfer is a Real-Time Payments transfer
    initiated outside of Increase to your account.

    ## Fields

      * `id` - The inbound Real-Time Payments transfer's identifier.
      * `account_id` - The Account to which the transfer was sent.
      * `account_number_id` - The identifier of the Account Number to which this transfer was
        sent.
      * `amount` - The amount in USD cents.
      * `confirmation` - If your transfer is confirmed, this will contain details of the
        confirmation.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `creditor_name` - The name the sender of the transfer specified as the recipient of the
        transfer.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code of the
        transfer's currency. This will always be "USD" for a Real-Time Payments
        transfer.
      * `debtor_account_number` - The account number of the account that sent the transfer.
      * `debtor_name` - The name provided by the sender of the transfer.
      * `debtor_routing_number` - The routing number of the account that sent the transfer.
      * `decline` - If your transfer is declined, this will contain details of the decline.
      * `status` - The lifecycle status of the transfer.
      * `transaction_identification` - The Real-Time Payments network identification of the
        transfer.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_real_time_payments_transfer`.
      * `unstructured_remittance_information` - Additional information included with the
        transfer.
    """

    defmodule Confirmation do
      @moduledoc """
      If your transfer is confirmed, this will contain details of the
      confirmation.

      ## Fields

        * `confirmed_at` - The time at which the transfer was confirmed.
        * `transaction_id` - The id of the transaction for the confirmed transfer.
      """

      defstruct [:confirmed_at, :transaction_id]

      @type t :: %__MODULE__{
              confirmed_at: DateTime.t(),
              transaction_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          confirmed_at: Increase.Decode.datetime(raw["confirmed_at"]),
          transaction_id: raw["transaction_id"]
        }
      end
    end

    defmodule Decline do
      @moduledoc """
      If your transfer is declined, this will contain details of the decline.

      ## Fields

        * `declined_at` - The time at which the transfer was declined.
        * `declined_transaction_id` - The id of the transaction for the declined transfer.
        * `reason` - The reason for the transfer decline.
      """

      defstruct [:declined_at, :declined_transaction_id, :reason]

      @type t :: %__MODULE__{
              declined_at: DateTime.t(),
              declined_transaction_id: String.t(),
              reason: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          declined_at: Increase.Decode.datetime(raw["declined_at"]),
          declined_transaction_id: raw["declined_transaction_id"],
          reason: raw["reason"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number_id,
      :amount,
      :confirmation,
      :created_at,
      :creditor_name,
      :currency,
      :debtor_account_number,
      :debtor_name,
      :debtor_routing_number,
      :decline,
      :status,
      :transaction_identification,
      :type,
      :unstructured_remittance_information
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            account_number_id: String.t(),
            amount: integer(),
            confirmation: Confirmation.t() | nil,
            created_at: DateTime.t(),
            creditor_name: String.t(),
            currency: String.t(),
            debtor_account_number: String.t(),
            debtor_name: String.t(),
            debtor_routing_number: String.t(),
            decline: Decline.t() | nil,
            status: String.t(),
            transaction_identification: String.t(),
            type: String.t(),
            unstructured_remittance_information: String.t() | nil
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        account_number_id: raw["account_number_id"],
        amount: raw["amount"],
        confirmation: Increase.Decode.struct(raw["confirmation"], &Confirmation.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        creditor_name: raw["creditor_name"],
        currency: raw["currency"],
        debtor_account_number: raw["debtor_account_number"],
        debtor_name: raw["debtor_name"],
        debtor_routing_number: raw["debtor_routing_number"],
        decline: Increase.Decode.struct(raw["decline"], &Decline.decode/1),
        status: raw["status"],
        transaction_identification: raw["transaction_identification"],
        type: raw["type"],
        unstructured_remittance_information: raw["unstructured_remittance_information"]
      }
    end
  end

  @doc """
  Retrieve an Inbound Real-Time Payments Transfer

  `GET /inbound_real_time_payments_transfers/{inbound_real_time_payments_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundRealTimePaymentsTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, inbound_real_time_payments_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_real_time_payments_transfers/#{inbound_real_time_payments_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundRealTimePaymentsTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Inbound Real-Time Payments Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  InboundRealTimePaymentsTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /inbound_real_time_payments_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_real_time_payments_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &InboundRealTimePaymentsTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
