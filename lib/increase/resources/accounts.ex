defmodule Increase.Accounts do
  @moduledoc """
  Accounts are your bank accounts with Increase. They store money, receive
  transfers, and send payments. They earn interest and have depository insurance.

  See https://increase.com/documentation/api/accounts for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule Account do
    @moduledoc """
    Accounts are your bank accounts with Increase. They store money, receive
    transfers, and send payments. They earn interest and have depository
    insurance.

    ## Fields

      * `id` - The Account identifier.
      * `account_revenue_rate` - The account revenue rate currently being earned on the account,
        as a string containing a decimal number. For example, a 1%
        account revenue rate would be represented as "0.01". Account
        revenue is a type of non-interest income accrued on the
        account.
      * `bank` - The bank the Account is with.
      * `closed_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Account was closed.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Account was created.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the Account
        currency.
      * `entity_id` - The identifier for the Entity the Account belongs to.
      * `funding` - Whether the Account is funded by a loan or by deposits.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `informational_entity_id` - The identifier of an Entity that, while not owning the
        Account, is associated with its activity.
      * `interest_rate` - The interest rate currently being earned on the account, as a string
        containing a decimal number. For example, a 1% interest rate would be
        represented as "0.01".
      * `loan` - The Account's loan-related information, if the Account is a loan account.
      * `name` - The name you choose for the Account.
      * `program_id` - The identifier of the Program determining the compliance and commercial
        terms of this Account.
      * `status` - The status of the Account.
      * `type` - A constant representing the object's type. For this resource it will always be
        `account`.
    """

    defmodule Loan do
      @moduledoc """
      The Account's loan-related information, if the Account is a loan account.

      ## Fields

        * `credit_limit` - The maximum amount of money that can be borrowed on the Account.
        * `grace_period_days` - The number of days after the statement date that the Account can
          be past due before being considered delinquent.
        * `maturity_date` - The date on which the loan matures.
        * `statement_day_of_month` - The day of the month on which the loan statement is
          generated.
        * `statement_payment_type` - The type of payment for the loan.
      """

      defstruct [
        :credit_limit,
        :grace_period_days,
        :maturity_date,
        :statement_day_of_month,
        :statement_payment_type
      ]

      @type t :: %__MODULE__{
              credit_limit: integer(),
              grace_period_days: integer(),
              maturity_date: Date.t() | nil,
              statement_day_of_month: integer(),
              statement_payment_type: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          credit_limit: raw["credit_limit"],
          grace_period_days: raw["grace_period_days"],
          maturity_date: Increase.Decode.date(raw["maturity_date"]),
          statement_day_of_month: raw["statement_day_of_month"],
          statement_payment_type: raw["statement_payment_type"]
        }
      end
    end

    defstruct [
      :id,
      :account_revenue_rate,
      :bank,
      :closed_at,
      :created_at,
      :currency,
      :entity_id,
      :funding,
      :idempotency_key,
      :informational_entity_id,
      :interest_rate,
      :loan,
      :name,
      :program_id,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_revenue_rate: String.t() | nil,
            bank: String.t(),
            closed_at: DateTime.t() | nil,
            created_at: DateTime.t(),
            currency: String.t(),
            entity_id: String.t(),
            funding: String.t(),
            idempotency_key: String.t() | nil,
            informational_entity_id: String.t() | nil,
            interest_rate: String.t(),
            loan: Loan.t() | nil,
            name: String.t(),
            program_id: String.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_revenue_rate: raw["account_revenue_rate"],
        bank: raw["bank"],
        closed_at: Increase.Decode.datetime(raw["closed_at"]),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        currency: raw["currency"],
        entity_id: raw["entity_id"],
        funding: raw["funding"],
        idempotency_key: raw["idempotency_key"],
        informational_entity_id: raw["informational_entity_id"],
        interest_rate: raw["interest_rate"],
        loan: Increase.Decode.struct(raw["loan"], &Loan.decode/1),
        name: raw["name"],
        program_id: raw["program_id"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  defmodule BalanceLookup do
    @moduledoc """
    Represents a request to lookup the balance of an Account at a given point in
    time.

    ## Fields

      * `account_id` - The identifier for the account for which the balance was queried.
      * `available_balance` - The Account's available balance, representing the current balance
        less any open Pending Transactions on the Account.
      * `current_balance` - The Account's current balance, representing the sum of all posted
        Transactions on the Account.
      * `loan` - The loan balances for the Account.
      * `type` - A constant representing the object's type. For this resource it will always be
        `balance_lookup`.
    """

    defmodule Loan do
      @moduledoc """
      The loan balances for the Account.

      ## Fields

        * `due_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
          loan payment is due.
        * `due_balance` - The total amount due on the loan.
        * `past_due_balance` - The amount past due on the loan.
      """

      defstruct [:due_at, :due_balance, :past_due_balance]

      @type t :: %__MODULE__{
              due_at: DateTime.t() | nil,
              due_balance: integer(),
              past_due_balance: integer()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          due_at: Increase.Decode.datetime(raw["due_at"]),
          due_balance: raw["due_balance"],
          past_due_balance: raw["past_due_balance"]
        }
      end
    end

    defstruct [:account_id, :available_balance, :current_balance, :loan, :type]

    @type t :: %__MODULE__{
            account_id: String.t(),
            available_balance: integer(),
            current_balance: integer(),
            loan: Loan.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        account_id: raw["account_id"],
        available_balance: raw["available_balance"],
        current_balance: raw["current_balance"],
        loan: Increase.Decode.struct(raw["loan"], &Loan.decode/1),
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an Account

  `POST /accounts`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Account.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/accounts"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Account.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an Account

  `GET /accounts/{account_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Account.t()} | {:error, Increase.Error.t()}
  def retrieve(client, account_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/accounts/#{account_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Account.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update an Account

  `PATCH /accounts/{account_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Account.t()} | {:error, Increase.Error.t()}
  def update(client, account_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/accounts/#{account_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Account.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Accounts

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  Account{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /accounts`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/accounts"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &Account.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve the current and available balances for an account in minor units of
  the account's currency. Learn more about [account
  balances].

  `GET /accounts/{account_id}/balance`
  """
  @spec balance(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, BalanceLookup.t()} | {:error, Increase.Error.t()}
  def balance(client, account_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/accounts/#{account_id}/balance"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path,
           query: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, BalanceLookup.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Close an Account

  `POST /accounts/{account_id}/close`
  """
  @spec close(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Account.t()} | {:error, Increase.Error.t()}
  def close(client, account_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/accounts/#{account_id}/close"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Account.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
