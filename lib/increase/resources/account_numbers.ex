defmodule Increase.AccountNumbers do
  @moduledoc """
  Each account can have multiple account and routing numbers. We recommend that
  you use a set per vendor. This is similar to how you use different passwords for
  different websites. Account numbers can also be used to seamlessly reconcile
  inbound payments. Generating a unique account number per vendor ensures you
  always know the originator of an incoming payment.

  See https://increase.com/documentation/api/account-numbers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule AccountNumber do
    @moduledoc """
    Each account can have multiple account and routing numbers. We recommend
    that you use a set per vendor. This is similar to how you use different
    passwords for different websites. Account numbers can also be used to
    seamlessly reconcile inbound payments. Generating a unique account number
    per vendor ensures you always know the originator of an incoming payment.

    ## Fields

      * `id` - The Account Number identifier.
      * `account_id` - The identifier for the account this Account Number belongs to.
      * `account_number` - The account number.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Account Number was created.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `inbound_ach` - Properties related to how this Account Number handles inbound ACH
        transfers.
      * `inbound_checks` - Properties related to how this Account Number should handle inbound
        check withdrawals.
      * `name` - The name you choose for the Account Number.
      * `routing_number` - The American Bankers' Association (ABA) Routing Transit Number (RTN).
      * `status` - This indicates if payments can be made to the Account Number.
      * `type` - A constant representing the object's type. For this resource it will always be
        `account_number`.
    """

    defmodule InboundACH do
      @moduledoc """
      Properties related to how this Account Number handles inbound ACH transfers.

      ## Fields

        * `debit_status` - Whether ACH debits are allowed against this Account Number. Note that
          they will still be declined if this is `allowed` if the Account
          Number is not active.
      """

      defstruct [:debit_status]

      @type t :: %__MODULE__{
              debit_status: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          debit_status: raw["debit_status"]
        }
      end
    end

    defmodule InboundChecks do
      @moduledoc """
      Properties related to how this Account Number should handle inbound check
      withdrawals.

      ## Fields

        * `status` - How Increase should process checks with this account number printed on
          them.
      """

      defstruct [:status]

      @type t :: %__MODULE__{
              status: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          status: raw["status"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number,
      :created_at,
      :idempotency_key,
      :inbound_ach,
      :inbound_checks,
      :name,
      :routing_number,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            account_number: String.t(),
            created_at: DateTime.t(),
            idempotency_key: String.t() | nil,
            inbound_ach: InboundACH.t(),
            inbound_checks: InboundChecks.t(),
            name: String.t(),
            routing_number: String.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        account_number: raw["account_number"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        idempotency_key: raw["idempotency_key"],
        inbound_ach: Increase.Decode.struct(raw["inbound_ach"], &InboundACH.decode/1),
        inbound_checks: Increase.Decode.struct(raw["inbound_checks"], &InboundChecks.decode/1),
        name: raw["name"],
        routing_number: raw["routing_number"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an Account Number

  `POST /account_numbers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, AccountNumber.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_numbers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, AccountNumber.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an Account Number

  `GET /account_numbers/{account_number_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, AccountNumber.t()} | {:error, Increase.Error.t()}
  def retrieve(client, account_number_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_numbers/#{account_number_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, AccountNumber.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update an Account Number

  `PATCH /account_numbers/{account_number_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, AccountNumber.t()} | {:error, Increase.Error.t()}
  def update(client, account_number_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_numbers/#{account_number_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, AccountNumber.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Account Numbers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  AccountNumber{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /account_numbers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/account_numbers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &AccountNumber.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
