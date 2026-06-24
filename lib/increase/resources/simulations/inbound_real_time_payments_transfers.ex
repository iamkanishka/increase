defmodule Increase.Simulations.InboundRealTimePaymentsTransfers do
  @moduledoc """
  Sandbox-only simulations related to Inbound Real Time Payments Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an [Inbound Real-Time Payments
  Transfer](#inbound-real-time-payments-transfers) to your account. Real-Time
  Payments are a beta feature.

  `POST /simulations/inbound_real_time_payments_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.InboundRealTimePaymentsTransfers.InboundRealTimePaymentsTransfer.t()}
          | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_real_time_payments_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} ->
        {:ok,
         Increase.InboundRealTimePaymentsTransfers.InboundRealTimePaymentsTransfer.decode(body)}

      {:error, error} ->
        {:error, error}
    end
  end
end
