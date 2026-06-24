defmodule Increase.InboundCheckDeposits do
  @moduledoc """
  Inbound Check Deposits are records of third-parties attempting to deposit checks
  against your account.

  See https://increase.com/documentation/api/inbound-check-deposits for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule InboundCheckDeposit do
    @moduledoc """
    Inbound Check Deposits are records of third-parties attempting to deposit
    checks against your account.

    ## Fields

      * `id` - The deposit's identifier.
      * `accepted_at` - If the Inbound Check Deposit was accepted, the [ISO
        8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at which
        this took place.
      * `account_id` - The Account the check is being deposited against.
      * `account_number_id` - The Account Number the check is being deposited against.
      * `adjustments` - If the deposit or the return was adjusted by the sending institution,
        this will contain details of the adjustments.
      * `amount` - The deposited amount in USD cents.
      * `back_image_file_id` - The ID for the File containing the image of the back of the
        check.
      * `bank_of_first_deposit_routing_number` - The American Bankers' Association (ABA) Routing
        Transit Number (RTN) for the bank depositing
        this check. In some rare cases, this is not
        transmitted via Check21 and the value will be
        null.
      * `check_number` - The check number printed on the check being deposited.
      * `check_transfer_id` - If this deposit is for an existing Check Transfer, the identifier
        of that Check Transfer.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the deposit was attempted.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
        deposit.
      * `declined_at` - If the Inbound Check Deposit was declined, the [ISO
        8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at which
        this took place.
      * `declined_transaction_id` - If the deposit attempt has been rejected, the identifier of
        the Declined Transaction object created as a result of the
        failed deposit.
      * `deposit_return` - If you requested a return of this deposit, this will contain details
        of the return.
      * `front_image_file_id` - The ID for the File containing the image of the front of the
        check.
      * `payee_name_analysis` - Whether the details on the check match the recipient name of the
        check transfer. This is an optional feature, contact sales to
        enable.
      * `status` - The status of the Inbound Check Deposit.
      * `transaction_id` - If the deposit attempt has been accepted, the identifier of the
        Transaction object created as a result of the successful deposit.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_check_deposit`.
    """

    defmodule Adjustment do
      @moduledoc """
      The `InboundCheckDepositAdjustment` object.

      ## Fields

        * `adjusted_at` - The time at which the return adjustment was received.
        * `amount` - The amount of the adjustment.
        * `reason` - The reason for the adjustment.
        * `transaction_id` - The id of the transaction for the adjustment.
      """

      defstruct [:adjusted_at, :amount, :reason, :transaction_id]

      @type t :: %__MODULE__{
              adjusted_at: DateTime.t(),
              amount: integer(),
              reason: String.t(),
              transaction_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          adjusted_at: Increase.Decode.datetime(raw["adjusted_at"]),
          amount: raw["amount"],
          reason: raw["reason"],
          transaction_id: raw["transaction_id"]
        }
      end
    end

    defmodule DepositReturn do
      @moduledoc """
      If you requested a return of this deposit, this will contain details of the
      return.

      ## Fields

        * `reason` - The reason the deposit was returned.
        * `returned_at` - The time at which the deposit was returned.
        * `transaction_id` - The id of the transaction for the returned deposit.
      """

      defstruct [:reason, :returned_at, :transaction_id]

      @type t :: %__MODULE__{
              reason: String.t(),
              returned_at: DateTime.t(),
              transaction_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reason: raw["reason"],
          returned_at: Increase.Decode.datetime(raw["returned_at"]),
          transaction_id: raw["transaction_id"]
        }
      end
    end

    defstruct [
      :id,
      :accepted_at,
      :account_id,
      :account_number_id,
      :adjustments,
      :amount,
      :back_image_file_id,
      :bank_of_first_deposit_routing_number,
      :check_number,
      :check_transfer_id,
      :created_at,
      :currency,
      :declined_at,
      :declined_transaction_id,
      :deposit_return,
      :front_image_file_id,
      :payee_name_analysis,
      :status,
      :transaction_id,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            accepted_at: DateTime.t() | nil,
            account_id: String.t(),
            account_number_id: String.t() | nil,
            adjustments: [Adjustment.t()],
            amount: integer(),
            back_image_file_id: String.t() | nil,
            bank_of_first_deposit_routing_number: String.t() | nil,
            check_number: String.t() | nil,
            check_transfer_id: String.t() | nil,
            created_at: DateTime.t(),
            currency: String.t(),
            declined_at: DateTime.t() | nil,
            declined_transaction_id: String.t() | nil,
            deposit_return: DepositReturn.t() | nil,
            front_image_file_id: String.t() | nil,
            payee_name_analysis: String.t(),
            status: String.t(),
            transaction_id: String.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        accepted_at: Increase.Decode.datetime(raw["accepted_at"]),
        account_id: raw["account_id"],
        account_number_id: raw["account_number_id"],
        adjustments: Increase.Decode.list(raw["adjustments"], &Adjustment.decode/1),
        amount: raw["amount"],
        back_image_file_id: raw["back_image_file_id"],
        bank_of_first_deposit_routing_number: raw["bank_of_first_deposit_routing_number"],
        check_number: raw["check_number"],
        check_transfer_id: raw["check_transfer_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        currency: raw["currency"],
        declined_at: Increase.Decode.datetime(raw["declined_at"]),
        declined_transaction_id: raw["declined_transaction_id"],
        deposit_return: Increase.Decode.struct(raw["deposit_return"], &DepositReturn.decode/1),
        front_image_file_id: raw["front_image_file_id"],
        payee_name_analysis: raw["payee_name_analysis"],
        status: raw["status"],
        transaction_id: raw["transaction_id"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve an Inbound Check Deposit

  `GET /inbound_check_deposits/{inbound_check_deposit_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundCheckDeposit.t()} | {:error, Increase.Error.t()}
  def retrieve(client, inbound_check_deposit_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_check_deposits/#{inbound_check_deposit_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundCheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Inbound Check Deposits

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  InboundCheckDeposit{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /inbound_check_deposits`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_check_deposits"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &InboundCheckDeposit.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Decline an Inbound Check Deposit

  `POST /inbound_check_deposits/{inbound_check_deposit_id}/decline`
  """
  @spec decline(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundCheckDeposit.t()} | {:error, Increase.Error.t()}
  def decline(client, inbound_check_deposit_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_check_deposits/#{inbound_check_deposit_id}/decline"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundCheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Return an Inbound Check Deposit

  `POST /inbound_check_deposits/{inbound_check_deposit_id}/return`
  """
  @spec return(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, InboundCheckDeposit.t()} | {:error, Increase.Error.t()}
  def return(client, inbound_check_deposit_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_check_deposits/#{inbound_check_deposit_id}/return"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, InboundCheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
