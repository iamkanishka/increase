defmodule Increase.InboundWireDrawdownRequests do
  @moduledoc """
  Inbound wire drawdown requests are requests from someone else to send them a
  wire. For more information, see our
  [Wire Drawdown Requests documentation].

  See https://increase.com/documentation/api/inbound-wire-drawdown-requests for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule InboundWireDrawdownRequest do
    @moduledoc """
    Inbound wire drawdown requests are requests from someone else to send them a
    wire. For more information, see our [Wire Drawdown Requests
    documentation].

    ## Fields

      * `id` - The Wire drawdown request identifier.
      * `amount` - The amount being requested in cents.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the inbound wire drawdown request was created.
      * `creditor_account_number` - The creditor's account number.
      * `creditor_address_line1` - A free-form address field set by the sender.
      * `creditor_address_line2` - A free-form address field set by the sender.
      * `creditor_address_line3` - A free-form address field set by the sender.
      * `creditor_name` - A name set by the sender.
      * `creditor_routing_number` - The creditor's routing number.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the amount
        being requested. Will always be "USD".
      * `debtor_address_line1` - A free-form address field set by the sender.
      * `debtor_address_line2` - A free-form address field set by the sender.
      * `debtor_address_line3` - A free-form address field set by the sender.
      * `debtor_name` - A name set by the sender.
      * `end_to_end_identification` - A free-form reference string set by the sender, to help
        identify the drawdown request.
      * `input_message_accountability_data` - A unique identifier available to the originating
        and receiving banks, commonly abbreviated as IMAD.
        It is created when the wire is submitted to the
        Fedwire service and is helpful when debugging
        wires with the originating bank.
      * `instruction_identification` - The sending bank's identifier for the drawdown request.
      * `recipient_account_number_id` - The Account Number from which the recipient of this
        request is being requested to send funds.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_wire_drawdown_request`.
      * `unique_end_to_end_transaction_reference` - The Unique End-to-end Transaction Reference
        ([UETR](https://www.swift.com/payments/what-unique-end-end-transaction-reference-uetr))
        of the drawdown request.
      * `unstructured_remittance_information` - A free-form message set by the sender.
    """

    defstruct [
      :id,
      :amount,
      :created_at,
      :creditor_account_number,
      :creditor_address_line1,
      :creditor_address_line2,
      :creditor_address_line3,
      :creditor_name,
      :creditor_routing_number,
      :currency,
      :debtor_address_line1,
      :debtor_address_line2,
      :debtor_address_line3,
      :debtor_name,
      :end_to_end_identification,
      :input_message_accountability_data,
      :instruction_identification,
      :recipient_account_number_id,
      :type,
      :unique_end_to_end_transaction_reference,
      :unstructured_remittance_information
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            amount: integer(),
            created_at: DateTime.t(),
            creditor_account_number: String.t(),
            creditor_address_line1: String.t() | nil,
            creditor_address_line2: String.t() | nil,
            creditor_address_line3: String.t() | nil,
            creditor_name: String.t() | nil,
            creditor_routing_number: String.t(),
            currency: String.t(),
            debtor_address_line1: String.t() | nil,
            debtor_address_line2: String.t() | nil,
            debtor_address_line3: String.t() | nil,
            debtor_name: String.t() | nil,
            end_to_end_identification: String.t() | nil,
            input_message_accountability_data: String.t() | nil,
            instruction_identification: String.t() | nil,
            recipient_account_number_id: String.t(),
            type: String.t(),
            unique_end_to_end_transaction_reference: String.t() | nil,
            unstructured_remittance_information: String.t() | nil
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        amount: raw["amount"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        creditor_account_number: raw["creditor_account_number"],
        creditor_address_line1: raw["creditor_address_line1"],
        creditor_address_line2: raw["creditor_address_line2"],
        creditor_address_line3: raw["creditor_address_line3"],
        creditor_name: raw["creditor_name"],
        creditor_routing_number: raw["creditor_routing_number"],
        currency: raw["currency"],
        debtor_address_line1: raw["debtor_address_line1"],
        debtor_address_line2: raw["debtor_address_line2"],
        debtor_address_line3: raw["debtor_address_line3"],
        debtor_name: raw["debtor_name"],
        end_to_end_identification: raw["end_to_end_identification"],
        input_message_accountability_data: raw["input_message_accountability_data"],
        instruction_identification: raw["instruction_identification"],
        recipient_account_number_id: raw["recipient_account_number_id"],
        type: raw["type"],
        unique_end_to_end_transaction_reference: raw["unique_end_to_end_transaction_reference"],
        unstructured_remittance_information: raw["unstructured_remittance_information"]
      }
    end
  end

  @doc """
  Retrieve an Inbound Wire Drawdown Request

  `GET /inbound_wire_drawdown_requests/{inbound_wire_drawdown_request_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundWireDrawdownRequest.t()} | {:error, Increase.Error.t()}
  def retrieve(client, inbound_wire_drawdown_request_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_wire_drawdown_requests/#{inbound_wire_drawdown_request_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundWireDrawdownRequest.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Inbound Wire Drawdown Requests

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  InboundWireDrawdownRequest{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /inbound_wire_drawdown_requests`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_wire_drawdown_requests"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &InboundWireDrawdownRequest.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
