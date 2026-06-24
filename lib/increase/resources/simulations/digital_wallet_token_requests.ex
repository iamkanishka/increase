defmodule Increase.Simulations.DigitalWalletTokenRequests do
  @moduledoc """
  Sandbox-only simulations related to Digital Wallet Token Request.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  defmodule SimulationDigitalWalletTokenRequestNewResponse do
    @moduledoc """
    The results of a Digital Wallet Token simulation.

    ## Fields

      * `decline_reason` - If the simulated tokenization attempt was declined, this field
        contains details as to why.
      * `digital_wallet_token_id` - If the simulated tokenization attempt was accepted, this
        field contains the id of the Digital Wallet Token that was
        created.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_digital_wallet_token_request_simulation_result`.
    """

    defstruct [:decline_reason, :digital_wallet_token_id, :type]

    @type t :: %__MODULE__{
            decline_reason: String.t() | nil,
            digital_wallet_token_id: String.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        decline_reason: raw["decline_reason"],
        digital_wallet_token_id: raw["digital_wallet_token_id"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Simulates a user attempting to add a [Card](#cards) to a digital wallet such
  as Apple Pay.

  `POST /simulations/digital_wallet_token_requests`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, SimulationDigitalWalletTokenRequestNewResponse.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/digital_wallet_token_requests"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, SimulationDigitalWalletTokenRequestNewResponse.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
