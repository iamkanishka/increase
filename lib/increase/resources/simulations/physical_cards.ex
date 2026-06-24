defmodule Increase.Simulations.PhysicalCards do
  @moduledoc """
  Sandbox-only simulations related to Physical Card.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  This endpoint allows you to simulate receiving a tracking update for a
  Physical Card, to simulate the progress of a shipment.

  `POST /simulations/physical_cards/{physical_card_id}/tracking_updates`
  """
  @spec create(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Increase.PhysicalCards.PhysicalCard.t()} | {:error, Increase.Error.t()}
  def create(client, physical_card_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/physical_cards/#{physical_card_id}/tracking_updates"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.PhysicalCards.PhysicalCard.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  This endpoint allows you to simulate advancing the shipment status of a
  Physical Card, to simulate e.g., that a physical card was attempted shipped
  but then failed delivery.

  `POST /simulations/physical_cards/{physical_card_id}/advance_shipment`
  """
  @spec advance_shipment(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, Increase.PhysicalCards.PhysicalCard.t()} | {:error, Increase.Error.t()}
  def advance_shipment(client, physical_card_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/physical_cards/#{physical_card_id}/advance_shipment"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.PhysicalCards.PhysicalCard.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
