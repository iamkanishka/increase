defmodule Increase.IntrafiBalances do
  @moduledoc """
  When using IntraFi, each account's balance over the standard FDIC insurance
  amount is swept to various other institutions. Funds are rebalanced across banks
  as needed once per business day.

  See https://increase.com/documentation/api/intrafi-balances for the full API
  reference for this resource.
  """

  alias Increase.Client

  defmodule IntrafiBalance do
    @moduledoc """
    When using IntraFi, each account's balance over the standard FDIC insurance
    amount is swept to various other institutions. Funds are rebalanced across
    banks as needed once per business day.

    ## Fields

      * `balances` - Each entry represents a balance held at a different bank. IntraFi separates
        the total balance across many participating banks in the network.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the account
        currency.
      * `effective_date` - The date this balance reflects.
      * `total_balance` - The total balance, in minor units of `currency`. Increase reports this
        balance to IntraFi daily.
      * `type` - A constant representing the object's type. For this resource it will always be
        `intrafi_balance`.
    """

    defmodule Balance do
      @moduledoc """
      The `IntrafiBalanceBalance` object.

      ## Fields

        * `balance` - The balance, in minor units of `currency`, held with this bank.
        * `bank` - The name of the bank holding these funds.
        * `bank_location` - The primary location of the bank.
        * `fdic_certificate_number` - The Federal Deposit Insurance Corporation (FDIC)
          certificate number of the bank. Because many banks have
          the same or similar names, this can be used to uniquely
          identify the institution.
      """

      defmodule IntrafiBalanceBalancesBankLocation do
        @moduledoc """
        The primary location of the bank.

        ## Fields

          * `city` - The bank's city.
          * `state` - The bank's state.
        """

        defstruct [:city, :state]

        @type t :: %__MODULE__{
                city: String.t(),
                state: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            state: raw["state"]
          }
        end
      end

      defstruct [:balance, :bank, :bank_location, :fdic_certificate_number]

      @type t :: %__MODULE__{
              balance: integer(),
              bank: String.t(),
              bank_location: IntrafiBalanceBalancesBankLocation.t() | nil,
              fdic_certificate_number: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          balance: raw["balance"],
          bank: raw["bank"],
          bank_location:
            Increase.Decode.struct(
              raw["bank_location"],
              &IntrafiBalanceBalancesBankLocation.decode/1
            ),
          fdic_certificate_number: raw["fdic_certificate_number"]
        }
      end
    end

    defstruct [:balances, :currency, :effective_date, :total_balance, :type]

    @type t :: %__MODULE__{
            balances: [Balance.t()],
            currency: String.t(),
            effective_date: Date.t(),
            total_balance: integer(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        balances: Increase.Decode.list(raw["balances"], &Balance.decode/1),
        currency: raw["currency"],
        effective_date: Increase.Decode.date(raw["effective_date"]),
        total_balance: raw["total_balance"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Returns the IntraFi balance for the given account. IntraFi may sweep funds
  to multiple banks. This endpoint will include both the total balance and the
  amount swept to each institution.

  `GET /accounts/{account_id}/intrafi_balance`
  """
  @spec intrafi_balance(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, IntrafiBalance.t()} | {:error, Increase.Error.t()}
  def intrafi_balance(client, account_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/accounts/#{account_id}/intrafi_balance"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, IntrafiBalance.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
