defmodule Increase.Simulations.InboundWireDrawdownRequests do
  @moduledoc """
  Sandbox-only simulations related to Inbound Wire Drawdown Request.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates receiving an [Inbound Wire Drawdown
  Request](#inbound-wire-drawdown-requests).

  `POST /simulations/inbound_wire_drawdown_requests`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.InboundWireDrawdownRequests.InboundWireDrawdownRequest.t()}
          | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_wire_drawdown_requests"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} ->
        {:ok, Increase.InboundWireDrawdownRequests.InboundWireDrawdownRequest.decode(body)}

      {:error, error} ->
        {:error, error}
    end
  end
end
