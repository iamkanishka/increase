defmodule Increase.Simulations.CardSettlements do
  @moduledoc """
  Sandbox-only simulations related to Card Settlement.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the settlement of an authorization by a card acquirer. After a
  card authorization is created, the merchant will eventually send a
  settlement. This simulates that event, which may occur many days after the
  purchase in production. The amount settled can be different from the amount
  originally authorized, for example, when adding a tip to a restaurant bill.

  `POST /simulations/card_settlements`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.Transactions.Transaction.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_settlements"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.Transactions.Transaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
