defmodule Increase.Simulations.InboundWireTransfers do
  @moduledoc """
  Sandbox-only simulations related to Inbound Wire Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an [Inbound Wire Transfer](#inbound-wire-transfers) to your
  account.

  `POST /simulations/inbound_wire_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.InboundWireTransfers.InboundWireTransfer.t()}
          | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_wire_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.InboundWireTransfers.InboundWireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
