defmodule Increase.AccountStatements do
  @moduledoc """
  Account Statements are generated monthly for every active Account. You can
  access the statement's data via the API or retrieve a PDF with its details via
  its associated File.

  See https://increase.com/documentation/api/account-statements for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule AccountStatement do
    @moduledoc """
    Account Statements are generated monthly for every active Account. You can
    access the statement's data via the API or retrieve a PDF with its details
    via its associated File.

    ## Fields

      * `id` - The Account Statement identifier.
      * `account_id` - The identifier for the Account this Account Statement belongs to.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Account Statement was created.
      * `ending_balance` - The Account's balance at the end of its statement period.
      * `file_id` - The identifier of the File containing a PDF of the statement.
      * `loan` - The loan balances.
      * `starting_balance` - The Account's balance at the start of its statement period.
      * `statement_period_end` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time
        representing the end of the period the Account Statement
        covers.
      * `statement_period_start` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time
        representing the start of the period the Account Statement
        covers.
      * `type` - A constant representing the object's type. For this resource it will always be
        `account_statement`.
    """

    defmodule Loan do
      @moduledoc """
      The loan balances.

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

    defstruct [
      :id,
      :account_id,
      :created_at,
      :ending_balance,
      :file_id,
      :loan,
      :starting_balance,
      :statement_period_end,
      :statement_period_start,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            created_at: DateTime.t(),
            ending_balance: integer(),
            file_id: String.t(),
            loan: Loan.t() | nil,
            starting_balance: integer(),
            statement_period_end: DateTime.t(),
            statement_period_start: DateTime.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        ending_balance: raw["ending_balance"],
        file_id: raw["file_id"],
        loan: Increase.Decode.struct(raw["loan"], &Loan.decode/1),
        starting_balance: raw["starting_balance"],
        statement_period_end: Increase.Decode.datetime(raw["statement_period_end"]),
        statement_period_start: Increase.Decode.datetime(raw["statement_period_start"]),
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve an Account Statement

  `GET /account_statements/{account_statement_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, AccountStatement.t()} | {:error, Increase.Error.t()}
  def retrieve(client, account_statement_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_statements/#{account_statement_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, AccountStatement.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Account Statements

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  AccountStatement{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /account_statements`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_statements"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &AccountStatement.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
