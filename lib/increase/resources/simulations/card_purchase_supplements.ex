defmodule Increase.Simulations.CardPurchaseSupplements do
  @moduledoc """
  Sandbox-only simulations related to Card Purchase Supplement.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the creation of a Card Purchase Supplement (Level 3 data) for a
  card settlement. This happens asynchronously in production when Visa sends
  enhanced transaction data about a purchase.

  `POST /simulations/card_purchase_supplements`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.CardPurchaseSupplements.CardPurchaseSupplement.t()}
          | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_purchase_supplements"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.CardPurchaseSupplements.CardPurchaseSupplement.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
