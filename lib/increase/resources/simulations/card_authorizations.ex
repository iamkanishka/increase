defmodule Increase.Simulations.CardAuthorizations do
  @moduledoc """
  Sandbox-only simulations related to Card Authorization.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  defmodule SimulationCardAuthorizationNewResponse do
    @moduledoc """
    The results of a Card Authorization simulation.

    ## Fields

      * `declined_transaction` - If the authorization attempt fails, this will contain the
        resulting [Declined Transaction](#declined-transactions)
        object. The Declined Transaction's `source` will be of
        `category: card_decline`.
      * `pending_transaction` - If the authorization attempt succeeds, this will contain the
        resulting Pending Transaction object. The Pending Transaction's
        `source` will be of `category: card_authorization`.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_card_authorization_simulation_result`.
    """

    defstruct [:declined_transaction, :pending_transaction, :type]

    @type t :: %__MODULE__{
            declined_transaction: Increase.DeclinedTransactions.DeclinedTransaction.t() | nil,
            pending_transaction: Increase.PendingTransactions.PendingTransaction.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        declined_transaction:
          Increase.Decode.struct(
            raw["declined_transaction"],
            &Increase.DeclinedTransactions.DeclinedTransaction.decode/1
          ),
        pending_transaction:
          Increase.Decode.struct(
            raw["pending_transaction"],
            &Increase.PendingTransactions.PendingTransaction.decode/1
          ),
        type: raw["type"]
      }
    end
  end

  @doc """
  Simulates a purchase authorization on a [Card](#cards). Depending on the
  balance available to the card and the `amount` submitted, the authorization
  activity will result in a [Pending Transaction](#pending-transactions) of
  type `card_authorization` or a [Declined
  Transaction](#declined-transactions) of type `card_decline`. You can pass
  either a Card id or a [Digital Wallet Token](#digital-wallet-tokens) id to
  simulate the two different ways purchases can be made.

  `POST /simulations/card_authorizations`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, SimulationCardAuthorizationNewResponse.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_authorizations"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, SimulationCardAuthorizationNewResponse.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
