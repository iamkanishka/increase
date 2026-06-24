defmodule Increase.WireDrawdownRequests do
  @moduledoc """
  Wire drawdown requests enable you to request that someone else send you a wire.
  Because there is nuance to making sure your counterparty's bank processes these
  correctly, we ask that you reach out to
  [support@increase.com](mailto:support@increase.com) to enable this feature so we
  can help you plan your integration. For more information, see our
  [Wire Drawdown Requests documentation].

  See https://increase.com/documentation/api/wire-drawdown-requests for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule WireDrawdownRequest do
    @moduledoc """
    Wire drawdown requests enable you to request that someone else send you a
    wire. Because there is nuance to making sure your counterparty's bank
    processes these correctly, we ask that you reach out to
    [support@increase.com](mailto:support@increase.com) to enable this feature
    so we can help you plan your integration. For more information, see our
    [Wire Drawdown Requests
    documentation].

    ## Fields

      * `id` - The Wire drawdown request identifier.
      * `account_number_id` - The Account Number to which the debtor—the recipient of this
        request—is being requested to send funds.
      * `amount` - The amount being requested in cents.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the wire drawdown request was created.
      * `creditor_address` - The creditor's address.
      * `creditor_name` - The creditor's name.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the amount
        being requested. Will always be "USD".
      * `debtor_account_number` - The debtor's account number.
      * `debtor_address` - The debtor's address.
      * `debtor_external_account_id` - The debtor's external account identifier.
      * `debtor_name` - The debtor's name.
      * `debtor_routing_number` - The debtor's routing number.
      * `end_to_end_identification` - A free-form reference string set by the sender, to be
        mirrored back in the subsequent wire transfer.
      * `fulfillment_inbound_wire_transfer_id` - If the recipient fulfills the drawdown request
        by sending funds, then this will be the
        identifier of the corresponding Transaction.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `status` - The lifecycle status of the drawdown request.
      * `submission` - After the drawdown request is submitted to Fedwire, this will contain
        supplemental details.
      * `type` - A constant representing the object's type. For this resource it will always be
        `wire_drawdown_request`.
      * `unique_end_to_end_transaction_reference` - The unique end-to-end transaction reference
        ([UETR](https://www.swift.com/payments/what-unique-end-end-transaction-reference-uetr))
        of the drawdown request.
      * `unstructured_remittance_information` - Remittance information the debtor will see as
        part of the drawdown request.
    """

    defmodule CreditorAddress do
      @moduledoc """
      The creditor's address.

      ## Fields

        * `city` - The city, district, town, or village of the address.
        * `country` - The two-letter [ISO 3166-1
          alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code for the
          country of the address.
        * `line1` - The first line of the address.
        * `line2` - The second line of the address.
        * `postal_code` - The ZIP code of the address.
        * `state` - The address state.
      """

      defstruct [:city, :country, :line1, :line2, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t(),
              country: String.t(),
              line1: String.t(),
              line2: String.t() | nil,
              postal_code: String.t() | nil,
              state: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          country: raw["country"],
          line1: raw["line1"],
          line2: raw["line2"],
          postal_code: raw["postal_code"],
          state: raw["state"]
        }
      end
    end

    defmodule DebtorAddress do
      @moduledoc """
      The debtor's address.

      ## Fields

        * `city` - The city, district, town, or village of the address.
        * `country` - The two-letter [ISO 3166-1
          alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code for the
          country of the address.
        * `line1` - The first line of the address.
        * `line2` - The second line of the address.
        * `postal_code` - The ZIP code of the address.
        * `state` - The address state.
      """

      defstruct [:city, :country, :line1, :line2, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t(),
              country: String.t(),
              line1: String.t(),
              line2: String.t() | nil,
              postal_code: String.t() | nil,
              state: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          country: raw["country"],
          line1: raw["line1"],
          line2: raw["line2"],
          postal_code: raw["postal_code"],
          state: raw["state"]
        }
      end
    end

    defmodule Submission do
      @moduledoc """
      After the drawdown request is submitted to Fedwire, this will contain
      supplemental details.

      ## Fields

        * `input_message_accountability_data` - The input message accountability data (IMAD)
          uniquely identifying the submission with
          Fedwire.
      """

      defstruct [:input_message_accountability_data]

      @type t :: %__MODULE__{
              input_message_accountability_data: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          input_message_accountability_data: raw["input_message_accountability_data"]
        }
      end
    end

    defstruct [
      :id,
      :account_number_id,
      :amount,
      :created_at,
      :creditor_address,
      :creditor_name,
      :currency,
      :debtor_account_number,
      :debtor_address,
      :debtor_external_account_id,
      :debtor_name,
      :debtor_routing_number,
      :end_to_end_identification,
      :fulfillment_inbound_wire_transfer_id,
      :idempotency_key,
      :status,
      :submission,
      :type,
      :unique_end_to_end_transaction_reference,
      :unstructured_remittance_information
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_number_id: String.t(),
            amount: integer(),
            created_at: DateTime.t(),
            creditor_address: CreditorAddress.t(),
            creditor_name: String.t(),
            currency: String.t(),
            debtor_account_number: String.t(),
            debtor_address: DebtorAddress.t(),
            debtor_external_account_id: String.t() | nil,
            debtor_name: String.t(),
            debtor_routing_number: String.t(),
            end_to_end_identification: String.t() | nil,
            fulfillment_inbound_wire_transfer_id: String.t() | nil,
            idempotency_key: String.t() | nil,
            status: String.t(),
            submission: Submission.t() | nil,
            type: String.t(),
            unique_end_to_end_transaction_reference: String.t() | nil,
            unstructured_remittance_information: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_number_id: raw["account_number_id"],
        amount: raw["amount"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        creditor_address:
          Increase.Decode.struct(raw["creditor_address"], &CreditorAddress.decode/1),
        creditor_name: raw["creditor_name"],
        currency: raw["currency"],
        debtor_account_number: raw["debtor_account_number"],
        debtor_address: Increase.Decode.struct(raw["debtor_address"], &DebtorAddress.decode/1),
        debtor_external_account_id: raw["debtor_external_account_id"],
        debtor_name: raw["debtor_name"],
        debtor_routing_number: raw["debtor_routing_number"],
        end_to_end_identification: raw["end_to_end_identification"],
        fulfillment_inbound_wire_transfer_id: raw["fulfillment_inbound_wire_transfer_id"],
        idempotency_key: raw["idempotency_key"],
        status: raw["status"],
        submission: Increase.Decode.struct(raw["submission"], &Submission.decode/1),
        type: raw["type"],
        unique_end_to_end_transaction_reference: raw["unique_end_to_end_transaction_reference"],
        unstructured_remittance_information: raw["unstructured_remittance_information"]
      }
    end
  end

  @doc """
  Create a Wire Drawdown Request

  `POST /wire_drawdown_requests`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, WireDrawdownRequest.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_drawdown_requests"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, WireDrawdownRequest.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Wire Drawdown Request

  `GET /wire_drawdown_requests/{wire_drawdown_request_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, WireDrawdownRequest.t()} | {:error, Increase.Error.t()}
  def retrieve(client, wire_drawdown_request_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_drawdown_requests/#{wire_drawdown_request_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, WireDrawdownRequest.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Wire Drawdown Requests

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  WireDrawdownRequest{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /wire_drawdown_requests`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_drawdown_requests"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &WireDrawdownRequest.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
