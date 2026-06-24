defmodule Increase.Simulations.CardIncrements do
  @moduledoc """
  Sandbox-only simulations related to Card Increment.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the increment of an authorization by a card acquirer. An
  authorization can be incremented multiple times.

  `POST /simulations/card_increments`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.CardPayments.CardPayment.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_increments"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.CardPayments.CardPayment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
