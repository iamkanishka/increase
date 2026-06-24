defmodule Increase.CheckDeposits do
  @moduledoc """
  Check Deposits allow you to deposit images of paper checks into your account.

  See https://increase.com/documentation/api/check-deposits for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CheckDeposit do
    @moduledoc """
    Check Deposits allow you to deposit images of paper checks into your
    account.

    ## Fields

      * `id` - The deposit's identifier.
      * `account_id` - The Account the check was deposited into.
      * `amount` - The deposited amount in USD cents.
      * `back_image_file_id` - The ID for the File containing the image of the back of the
        check.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `deposit_acceptance` - Once your deposit is successfully parsed and accepted by
        Increase, this will contain details of the parsed check.
      * `deposit_adjustments` - If the deposit or the return was adjusted by the receiving
        institution, this will contain details of the adjustments.
      * `deposit_rejection` - If your deposit is rejected by Increase, this will contain details
        as to why it was rejected.
      * `deposit_return` - If your deposit is returned, this will contain details as to why it
        was returned.
      * `deposit_submission` - After the check is parsed, it is submitted to the Check21 network
        for processing. This will contain details of the submission.
      * `description` - The description of the Check Deposit, for display purposes only.
      * `front_image_file_id` - The ID for the File containing the image of the front of the
        check.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `inbound_funds_hold` - Increase will sometimes hold the funds for Check Deposits. If
        funds are held, this sub-object will contain details of the hold.
      * `inbound_mail_item_id` - If the Check Deposit was the result of an Inbound Mail Item,
        this will contain the identifier of the Inbound Mail Item.
      * `lockbox_recipient_id` - If the Check Deposit was the result of an Inbound Mail Item
        routed to a Lockbox Recipient, this will contain the identifier
        of the Lockbox Recipient that received it.
      * `status` - The status of the Check Deposit.
      * `transaction_id` - The ID for the Transaction created by the deposit.
      * `type` - A constant representing the object's type. For this resource it will always be
        `check_deposit`.
    """

    defmodule DepositAcceptance do
      @moduledoc """
      Once your deposit is successfully parsed and accepted by Increase, this will
      contain details of the parsed check.

      ## Fields

        * `account_number` - The account number printed on the check. This is an account at the
          bank that issued the check.
        * `amount` - The amount to be deposited in the minor unit of the transaction's currency.
          For dollars, for example, this is cents.
        * `auxiliary_on_us` - An additional line of metadata printed on the check. This
          typically includes the check number for business checks.
        * `check_deposit_id` - The ID of the Check Deposit that was accepted.
        * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
          transaction's currency.
        * `routing_number` - The routing number printed on the check. This is a routing number
          for the bank that issued the check.
        * `serial_number` - The check serial number, if present, for consumer checks. For
          business checks, the serial number is usually in the
          `auxiliary_on_us` field.
      """

      defstruct [
        :account_number,
        :amount,
        :auxiliary_on_us,
        :check_deposit_id,
        :currency,
        :routing_number,
        :serial_number
      ]

      @type t :: %__MODULE__{
              account_number: String.t(),
              amount: integer(),
              auxiliary_on_us: String.t() | nil,
              check_deposit_id: String.t(),
              currency: String.t(),
              routing_number: String.t(),
              serial_number: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_number: raw["account_number"],
          amount: raw["amount"],
          auxiliary_on_us: raw["auxiliary_on_us"],
          check_deposit_id: raw["check_deposit_id"],
          currency: raw["currency"],
          routing_number: raw["routing_number"],
          serial_number: raw["serial_number"]
        }
      end
    end

    defmodule DepositAdjustment do
      @moduledoc """
      The `CheckDepositDepositAdjustment` object.

      ## Fields

        * `adjusted_at` - The time at which the adjustment was received.
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

    defmodule DepositRejection do
      @moduledoc """
      If your deposit is rejected by Increase, this will contain details as to why
      it was rejected.

      ## Fields

        * `amount` - The rejected amount in the minor unit of check's currency. For dollars, for
          example, this is cents.
        * `check_deposit_id` - The identifier of the Check Deposit that was rejected.
        * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
          check's currency.
        * `declined_transaction_id` - The identifier of the associated declined transaction.
        * `reason` - Why the check deposit was rejected.
        * `rejected_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the check deposit was rejected.
      """

      defstruct [
        :amount,
        :check_deposit_id,
        :currency,
        :declined_transaction_id,
        :reason,
        :rejected_at
      ]

      @type t :: %__MODULE__{
              amount: integer(),
              check_deposit_id: String.t(),
              currency: String.t(),
              declined_transaction_id: String.t(),
              reason: String.t(),
              rejected_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          amount: raw["amount"],
          check_deposit_id: raw["check_deposit_id"],
          currency: raw["currency"],
          declined_transaction_id: raw["declined_transaction_id"],
          reason: raw["reason"],
          rejected_at: Increase.Decode.datetime(raw["rejected_at"])
        }
      end
    end

    defmodule DepositReturn do
      @moduledoc """
      If your deposit is returned, this will contain details as to why it was
      returned.

      ## Fields

        * `amount` - The returned amount in USD cents.
        * `check_deposit_id` - The identifier of the Check Deposit that was returned.
        * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
          transaction's currency.
        * `return_reason` - Why this check was returned by the bank holding the account it was
          drawn against.
        * `returned_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the check deposit was returned.
        * `transaction_id` - The identifier of the transaction that reversed the original check
          deposit transaction.
      """

      defstruct [
        :amount,
        :check_deposit_id,
        :currency,
        :return_reason,
        :returned_at,
        :transaction_id
      ]

      @type t :: %__MODULE__{
              amount: integer(),
              check_deposit_id: String.t(),
              currency: String.t(),
              return_reason: String.t(),
              returned_at: DateTime.t(),
              transaction_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          amount: raw["amount"],
          check_deposit_id: raw["check_deposit_id"],
          currency: raw["currency"],
          return_reason: raw["return_reason"],
          returned_at: Increase.Decode.datetime(raw["returned_at"]),
          transaction_id: raw["transaction_id"]
        }
      end
    end

    defmodule DepositSubmission do
      @moduledoc """
      After the check is parsed, it is submitted to the Check21 network for
      processing. This will contain details of the submission.

      ## Fields

        * `back_file_id` - The ID for the File containing the check back image that was
          submitted to the Check21 network.
        * `front_file_id` - The ID for the File containing the check front image that was
          submitted to the Check21 network.
        * `submitted_at` - When the check deposit was submitted to the Check21 network for
          processing. During business days, this happens within a few hours of
          the check being accepted by Increase.
      """

      defstruct [:back_file_id, :front_file_id, :submitted_at]

      @type t :: %__MODULE__{
              back_file_id: String.t(),
              front_file_id: String.t(),
              submitted_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          back_file_id: raw["back_file_id"],
          front_file_id: raw["front_file_id"],
          submitted_at: Increase.Decode.datetime(raw["submitted_at"])
        }
      end
    end

    defmodule InboundFundsHold do
      @moduledoc """
      Increase will sometimes hold the funds for Check Deposits. If funds are
      held, this sub-object will contain details of the hold.

      ## Fields

        * `amount` - The held amount in the minor unit of the account's currency. For dollars,
          for example, this is cents.
        * `automatically_releases_at` - When the hold will be released automatically. Certain
          conditions may cause it to be released before this time.
        * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which
          the hold was created.
        * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
          hold's currency.
        * `held_transaction_id` - The ID of the Transaction for which funds were held.
        * `pending_transaction_id` - The ID of the Pending Transaction representing the held
          funds.
        * `released_at` - When the hold was released (if it has been released).
        * `status` - The status of the hold.
        * `type` - A constant representing the object's type. For this resource it will always
          be `inbound_funds_hold`.
      """

      defstruct [
        :amount,
        :automatically_releases_at,
        :created_at,
        :currency,
        :held_transaction_id,
        :pending_transaction_id,
        :released_at,
        :status,
        :type
      ]

      @type t :: %__MODULE__{
              amount: integer(),
              automatically_releases_at: DateTime.t(),
              created_at: DateTime.t(),
              currency: String.t(),
              held_transaction_id: String.t() | nil,
              pending_transaction_id: String.t() | nil,
              released_at: DateTime.t() | nil,
              status: String.t(),
              type: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          amount: raw["amount"],
          automatically_releases_at: Increase.Decode.datetime(raw["automatically_releases_at"]),
          created_at: Increase.Decode.datetime(raw["created_at"]),
          currency: raw["currency"],
          held_transaction_id: raw["held_transaction_id"],
          pending_transaction_id: raw["pending_transaction_id"],
          released_at: Increase.Decode.datetime(raw["released_at"]),
          status: raw["status"],
          type: raw["type"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :amount,
      :back_image_file_id,
      :created_at,
      :deposit_acceptance,
      :deposit_adjustments,
      :deposit_rejection,
      :deposit_return,
      :deposit_submission,
      :description,
      :front_image_file_id,
      :idempotency_key,
      :inbound_funds_hold,
      :inbound_mail_item_id,
      :lockbox_recipient_id,
      :status,
      :transaction_id,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            amount: integer(),
            back_image_file_id: String.t() | nil,
            created_at: DateTime.t(),
            deposit_acceptance: DepositAcceptance.t() | nil,
            deposit_adjustments: [DepositAdjustment.t()],
            deposit_rejection: DepositRejection.t() | nil,
            deposit_return: DepositReturn.t() | nil,
            deposit_submission: DepositSubmission.t() | nil,
            description: String.t() | nil,
            front_image_file_id: String.t(),
            idempotency_key: String.t() | nil,
            inbound_funds_hold: InboundFundsHold.t() | nil,
            inbound_mail_item_id: String.t() | nil,
            lockbox_recipient_id: String.t() | nil,
            status: String.t(),
            transaction_id: String.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        amount: raw["amount"],
        back_image_file_id: raw["back_image_file_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        deposit_acceptance:
          Increase.Decode.struct(raw["deposit_acceptance"], &DepositAcceptance.decode/1),
        deposit_adjustments:
          Increase.Decode.list(raw["deposit_adjustments"], &DepositAdjustment.decode/1),
        deposit_rejection:
          Increase.Decode.struct(raw["deposit_rejection"], &DepositRejection.decode/1),
        deposit_return: Increase.Decode.struct(raw["deposit_return"], &DepositReturn.decode/1),
        deposit_submission:
          Increase.Decode.struct(raw["deposit_submission"], &DepositSubmission.decode/1),
        description: raw["description"],
        front_image_file_id: raw["front_image_file_id"],
        idempotency_key: raw["idempotency_key"],
        inbound_funds_hold:
          Increase.Decode.struct(raw["inbound_funds_hold"], &InboundFundsHold.decode/1),
        inbound_mail_item_id: raw["inbound_mail_item_id"],
        lockbox_recipient_id: raw["lockbox_recipient_id"],
        status: raw["status"],
        transaction_id: raw["transaction_id"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Check Deposit

  `POST /check_deposits`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, CheckDeposit.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_deposits"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Check Deposit

  `GET /check_deposits/{check_deposit_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CheckDeposit.t()} | {:error, Increase.Error.t()}
  def retrieve(client, check_deposit_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_deposits/#{check_deposit_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Check Deposits

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CheckDeposit{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /check_deposits`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_deposits"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CheckDeposit.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
