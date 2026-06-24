defmodule Increase.InboundWireTransfers do
  @moduledoc """
  An Inbound Wire Transfer is a wire transfer initiated outside of Increase to
  your account.

  See https://increase.com/documentation/api/inbound-wire-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule InboundWireTransfer do
    @moduledoc """
    An Inbound Wire Transfer is a wire transfer initiated outside of Increase to
    your account.

    ## Fields

      * `id` - The inbound wire transfer's identifier.
      * `acceptance` - If the transfer is accepted, this will contain details of the acceptance.
      * `account_id` - The Account to which the transfer belongs.
      * `account_number_id` - The identifier of the Account Number to which this transfer was
        sent.
      * `amount` - The amount in USD cents.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the inbound wire transfer was created.
      * `creditor_address_line1` - A free-form address field set by the sender.
      * `creditor_address_line2` - A free-form address field set by the sender.
      * `creditor_address_line3` - A free-form address field set by the sender.
      * `creditor_name` - A name set by the sender.
      * `debtor_address_line1` - A free-form address field set by the sender.
      * `debtor_address_line2` - A free-form address field set by the sender.
      * `debtor_address_line3` - A free-form address field set by the sender.
      * `debtor_name` - A name set by the sender.
      * `description` - An Increase-constructed description of the transfer.
      * `end_to_end_identification` - A free-form reference string set by the sender, to help
        identify the transfer.
      * `input_message_accountability_data` - A unique identifier available to the originating
        and receiving banks, commonly abbreviated as IMAD.
        It is created when the wire is submitted to the
        Fedwire service and is helpful when debugging
        wires with the originating bank.
      * `instructing_agent_routing_number` - The American Banking Association (ABA) routing
        number of the bank that sent the wire.
      * `instruction_identification` - The sending bank's identifier for the wire transfer.
      * `purpose` - The reason for the wire transfer, as set by the sender.
      * `reversal` - If the transfer is reversed, this will contain details of the reversal.
      * `status` - The status of the transfer.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_wire_transfer`.
      * `unique_end_to_end_transaction_reference` - The Unique End-to-end Transaction Reference
        ([UETR](https://www.swift.com/payments/what-unique-end-end-transaction-reference-uetr))
        of the transfer.
      * `unstructured_remittance_information` - A free-form message set by the sender.
      * `wire_drawdown_request_id` - The wire drawdown request the inbound wire transfer is
        fulfilling.
    """

    defmodule Acceptance do
      @moduledoc """
      If the transfer is accepted, this will contain details of the acceptance.

      ## Fields

        * `accepted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was accepted.
        * `transaction_id` - The identifier of the transaction for the accepted transfer.
      """

      defstruct [:accepted_at, :transaction_id]

      @type t :: %__MODULE__{
              accepted_at: DateTime.t(),
              transaction_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          accepted_at: Increase.Decode.datetime(raw["accepted_at"]),
          transaction_id: raw["transaction_id"]
        }
      end
    end

    defmodule Reversal do
      @moduledoc """
      If the transfer is reversed, this will contain details of the reversal.

      ## Fields

        * `reason` - The reason for the reversal.
        * `reversed_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was reversed.
      """

      defstruct [:reason, :reversed_at]

      @type t :: %__MODULE__{
              reason: String.t(),
              reversed_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reason: raw["reason"],
          reversed_at: Increase.Decode.datetime(raw["reversed_at"])
        }
      end
    end

    defstruct [
      :id,
      :acceptance,
      :account_id,
      :account_number_id,
      :amount,
      :created_at,
      :creditor_address_line1,
      :creditor_address_line2,
      :creditor_address_line3,
      :creditor_name,
      :debtor_address_line1,
      :debtor_address_line2,
      :debtor_address_line3,
      :debtor_name,
      :description,
      :end_to_end_identification,
      :input_message_accountability_data,
      :instructing_agent_routing_number,
      :instruction_identification,
      :purpose,
      :reversal,
      :status,
      :type,
      :unique_end_to_end_transaction_reference,
      :unstructured_remittance_information,
      :wire_drawdown_request_id
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            acceptance: Acceptance.t() | nil,
            account_id: String.t(),
            account_number_id: String.t(),
            amount: integer(),
            created_at: DateTime.t(),
            creditor_address_line1: String.t() | nil,
            creditor_address_line2: String.t() | nil,
            creditor_address_line3: String.t() | nil,
            creditor_name: String.t() | nil,
            debtor_address_line1: String.t() | nil,
            debtor_address_line2: String.t() | nil,
            debtor_address_line3: String.t() | nil,
            debtor_name: String.t() | nil,
            description: String.t(),
            end_to_end_identification: String.t() | nil,
            input_message_accountability_data: String.t() | nil,
            instructing_agent_routing_number: String.t() | nil,
            instruction_identification: String.t() | nil,
            purpose: String.t() | nil,
            reversal: Reversal.t() | nil,
            status: String.t(),
            type: String.t(),
            unique_end_to_end_transaction_reference: String.t() | nil,
            unstructured_remittance_information: String.t() | nil,
            wire_drawdown_request_id: String.t() | nil
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        acceptance: Increase.Decode.struct(raw["acceptance"], &Acceptance.decode/1),
        account_id: raw["account_id"],
        account_number_id: raw["account_number_id"],
        amount: raw["amount"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        creditor_address_line1: raw["creditor_address_line1"],
        creditor_address_line2: raw["creditor_address_line2"],
        creditor_address_line3: raw["creditor_address_line3"],
        creditor_name: raw["creditor_name"],
        debtor_address_line1: raw["debtor_address_line1"],
        debtor_address_line2: raw["debtor_address_line2"],
        debtor_address_line3: raw["debtor_address_line3"],
        debtor_name: raw["debtor_name"],
        description: raw["description"],
        end_to_end_identification: raw["end_to_end_identification"],
        input_message_accountability_data: raw["input_message_accountability_data"],
        instructing_agent_routing_number: raw["instructing_agent_routing_number"],
        instruction_identification: raw["instruction_identification"],
        purpose: raw["purpose"],
        reversal: Increase.Decode.struct(raw["reversal"], &Reversal.decode/1),
        status: raw["status"],
        type: raw["type"],
        unique_end_to_end_transaction_reference: raw["unique_end_to_end_transaction_reference"],
        unstructured_remittance_information: raw["unstructured_remittance_information"],
        wire_drawdown_request_id: raw["wire_drawdown_request_id"]
      }
    end
  end

  @doc """
  Retrieve an Inbound Wire Transfer

  `GET /inbound_wire_transfers/{inbound_wire_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundWireTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, inbound_wire_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_wire_transfers/#{inbound_wire_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundWireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Inbound Wire Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  InboundWireTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /inbound_wire_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_wire_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &InboundWireTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Reverse an Inbound Wire Transfer

  `POST /inbound_wire_transfers/{inbound_wire_transfer_id}/reverse`
  """
  @spec reverse(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, InboundWireTransfer.t()} | {:error, Increase.Error.t()}
  def reverse(client, inbound_wire_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_wire_transfers/#{inbound_wire_transfer_id}/reverse"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, InboundWireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
