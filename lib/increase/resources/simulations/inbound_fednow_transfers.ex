defmodule Increase.Simulations.InboundFednowTransfers do
  @moduledoc """
  Sandbox-only simulations related to Inbound Fednow Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an [Inbound FedNow Transfer](#inbound-fednow-transfers) to your
  account.

  `POST /simulations/inbound_fednow_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.InboundFednowTransfers.InboundFednowTransfer.t()}
          | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_fednow_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.InboundFednowTransfers.InboundFednowTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
