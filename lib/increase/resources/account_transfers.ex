defmodule Increase.AccountTransfers do
  @moduledoc """
  Account transfers move funds between your own accounts at Increase (accounting
  systems often refer to these as Book Transfers). Account Transfers are free and
  synchronous. Upon creation they create two Transactions, one negative on the
  originating account and one positive on the destination account (unless the
  transfer requires approval, in which case the Transactions will be created when
  the transfer is approved).

  See https://increase.com/documentation/api/account-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule AccountTransfer do
    @moduledoc """
    Account transfers move funds between your own accounts at Increase
    (accounting systems often refer to these as Book Transfers). Account
    Transfers are free and synchronous. Upon creation they create two
    Transactions, one negative on the originating account and one positive on
    the destination account (unless the transfer requires approval, in which
    case the Transactions will be created when the transfer is approved).

    ## Fields

      * `id` - The Account Transfer's identifier.
      * `account_id` - The Account from which the transfer originated.
      * `amount` - The transfer amount in cents. This will always be positive and indicates the
        amount of money leaving the originating account.
      * `approval` - If your account requires approvals for transfers and the transfer was
        approved, this will contain details of the approval.
      * `cancellation` - If your account requires approvals for transfers and the transfer was
        not approved, this will contain details of the cancellation.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `created_by` - What object created the transfer, either via the API or the dashboard.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
        transfer's currency.
      * `description` - An internal-facing description for the transfer for display in the API
        and dashboard. This will also show in the description of the created
        Transactions.
      * `destination_account_id` - The destination Account's identifier.
      * `destination_transaction_id` - The identifier of the Transaction on the destination
        Account representing the received funds.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `pending_transaction_id` - The ID for the pending transaction representing the transfer.
        A pending transaction is created when the transfer [requires
        approval](https://increase.com/documentation/transfer-approvals#transfer-approvals)
        by someone else in your organization.
      * `status` - The lifecycle status of the transfer.
      * `transaction_id` - The identifier of the Transaction on the originating account
        representing the transferred funds.
      * `type` - A constant representing the object's type. For this resource it will always be
        `account_transfer`.
    """

    defmodule Approval do
      @moduledoc """
      If your account requires approvals for transfers and the transfer was
      approved, this will contain details of the approval.

      ## Fields

        * `approved_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was approved.
        * `approved_by` - If the Transfer was approved by a user in the dashboard, the email
          address of that user.
      """

      defstruct [:approved_at, :approved_by]

      @type t :: %__MODULE__{
              approved_at: DateTime.t(),
              approved_by: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          approved_at: Increase.Decode.datetime(raw["approved_at"]),
          approved_by: raw["approved_by"]
        }
      end
    end

    defmodule Cancellation do
      @moduledoc """
      If your account requires approvals for transfers and the transfer was not
      approved, this will contain details of the cancellation.

      ## Fields

        * `canceled_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the Transfer was canceled.
        * `canceled_by` - If the Transfer was canceled by a user in the dashboard, the email
          address of that user.
      """

      defstruct [:canceled_at, :canceled_by]

      @type t :: %__MODULE__{
              canceled_at: DateTime.t(),
              canceled_by: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          canceled_at: Increase.Decode.datetime(raw["canceled_at"]),
          canceled_by: raw["canceled_by"]
        }
      end
    end

    defmodule CreatedBy do
      @moduledoc """
      What object created the transfer, either via the API or the dashboard.

      ## Fields

        * `category` - The type of object that created this transfer.
        * `api_key` - If present, details about the API key that created the transfer.
        * `oauth_application` - If present, details about the OAuth Application that created the
          transfer.
        * `user` - If present, details about the User that created the transfer.
      """

      defmodule APIKey do
        @moduledoc """
        If present, details about the API key that created the transfer.

        ## Fields

          * `description` - The description set for the API key when it was created.
        """

        defstruct [:description]

        @type t :: %__MODULE__{
                description: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            description: raw["description"]
          }
        end
      end

      defmodule OAuthApplication do
        @moduledoc """
        If present, details about the OAuth Application that created the transfer.

        ## Fields

          * `name` - The name of the OAuth Application.
        """

        defstruct [:name]

        @type t :: %__MODULE__{
                name: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            name: raw["name"]
          }
        end
      end

      defmodule User do
        @moduledoc """
        If present, details about the User that created the transfer.

        ## Fields

          * `email` - The email address of the User.
        """

        defstruct [:email]

        @type t :: %__MODULE__{
                email: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            email: raw["email"]
          }
        end
      end

      defstruct [:category, :api_key, :oauth_application, :user]

      @type t :: %__MODULE__{
              category: String.t(),
              api_key: APIKey.t() | nil,
              oauth_application: OAuthApplication.t() | nil,
              user: User.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          category: raw["category"],
          api_key: Increase.Decode.struct(raw["api_key"], &APIKey.decode/1),
          oauth_application:
            Increase.Decode.struct(raw["oauth_application"], &OAuthApplication.decode/1),
          user: Increase.Decode.struct(raw["user"], &User.decode/1)
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :amount,
      :approval,
      :cancellation,
      :created_at,
      :created_by,
      :currency,
      :description,
      :destination_account_id,
      :destination_transaction_id,
      :idempotency_key,
      :pending_transaction_id,
      :status,
      :transaction_id,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            amount: integer(),
            approval: Approval.t() | nil,
            cancellation: Cancellation.t() | nil,
            created_at: DateTime.t(),
            created_by: CreatedBy.t() | nil,
            currency: String.t(),
            description: String.t(),
            destination_account_id: String.t(),
            destination_transaction_id: String.t() | nil,
            idempotency_key: String.t() | nil,
            pending_transaction_id: String.t() | nil,
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
        approval: Increase.Decode.struct(raw["approval"], &Approval.decode/1),
        cancellation: Increase.Decode.struct(raw["cancellation"], &Cancellation.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        currency: raw["currency"],
        description: raw["description"],
        destination_account_id: raw["destination_account_id"],
        destination_transaction_id: raw["destination_transaction_id"],
        idempotency_key: raw["idempotency_key"],
        pending_transaction_id: raw["pending_transaction_id"],
        status: raw["status"],
        transaction_id: raw["transaction_id"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an Account Transfer

  `POST /account_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, AccountTransfer.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, AccountTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an Account Transfer

  `GET /account_transfers/{account_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, AccountTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, account_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_transfers/#{account_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, AccountTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Account Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  AccountTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /account_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &AccountTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Approves an Account Transfer in status `pending_approval`.

  `POST /account_transfers/{account_transfer_id}/approve`
  """
  @spec approve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, AccountTransfer.t()} | {:error, Increase.Error.t()}
  def approve(client, account_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_transfers/#{account_transfer_id}/approve"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, AccountTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Cancels an Account Transfer in status `pending_approval`.

  `POST /account_transfers/{account_transfer_id}/cancel`
  """
  @spec cancel(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, AccountTransfer.t()} | {:error, Increase.Error.t()}
  def cancel(client, account_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_transfers/#{account_transfer_id}/cancel"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, AccountTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
