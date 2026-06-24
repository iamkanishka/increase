defmodule Increase.InboundFednowTransfers do
  @moduledoc """
  An Inbound FedNow Transfer is a FedNow transfer initiated outside of Increase to
  your account.

  See https://increase.com/documentation/api/inbound-fednow-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule InboundFednowTransfer do
    @moduledoc """
    An Inbound FedNow Transfer is a FedNow transfer initiated outside of
    Increase to your account.

    ## Fields

      * `id` - The inbound FedNow transfer's identifier.
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
        transfer's currency. This will always be "USD" for a FedNow transfer.
      * `debtor_account_number` - The account number of the account that sent the transfer.
      * `debtor_name` - The name provided by the sender of the transfer.
      * `debtor_routing_number` - The routing number of the account that sent the transfer.
      * `decline` - If your transfer is declined, this will contain details of the decline.
      * `status` - The lifecycle status of the transfer.
      * `transaction_id` - The identifier of the Transaction object created when the transfer
        was confirmed.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_fednow_transfer`.
      * `unstructured_remittance_information` - Additional information included with the
        transfer.
    """

    defmodule Confirmation do
      @moduledoc """
      If your transfer is confirmed, this will contain details of the
      confirmation.

      ## Fields

        * `transfer_id` - The identifier of the FedNow Transfer that led to this Transaction.
      """

      defstruct [:transfer_id]

      @type t :: %__MODULE__{
              transfer_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          transfer_id: raw["transfer_id"]
        }
      end
    end

    defmodule Decline do
      @moduledoc """
      If your transfer is declined, this will contain details of the decline.

      ## Fields

        * `reason` - Why the transfer was declined.
        * `transfer_id` - The identifier of the FedNow Transfer that led to this declined
          transaction.
      """

      defstruct [:reason, :transfer_id]

      @type t :: %__MODULE__{
              reason: String.t(),
              transfer_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reason: raw["reason"],
          transfer_id: raw["transfer_id"]
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
      :transaction_id,
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
            transaction_id: String.t() | nil,
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
        transaction_id: raw["transaction_id"],
        type: raw["type"],
        unstructured_remittance_information: raw["unstructured_remittance_information"]
      }
    end
  end

  @doc """
  Retrieve an Inbound FedNow Transfer

  `GET /inbound_fednow_transfers/{inbound_fednow_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundFednowTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, inbound_fednow_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_fednow_transfers/#{inbound_fednow_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundFednowTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Inbound FedNow Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  InboundFednowTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /inbound_fednow_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_fednow_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &InboundFednowTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
