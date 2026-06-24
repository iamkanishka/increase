defmodule Increase.Simulations.RealTimePaymentsTransfers do
  @moduledoc """
  Sandbox-only simulations related to Real Time Payments Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates submission of a [Real-Time Payments
  Transfer](#real-time-payments-transfers) and handling the response from the
  destination financial institution. This transfer must first have a `status`
  of `pending_submission`.

  `POST /simulations/real_time_payments_transfers/{real_time_payments_transfer_id}/complete`
  """
  @spec complete(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Increase.RealTimePaymentsTransfers.RealTimePaymentsTransfer.t()}
          | {:error, Increase.Error.t()}
  def complete(client, real_time_payments_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/real_time_payments_transfers/#{real_time_payments_transfer_id}/complete"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} ->
        {:ok, Increase.RealTimePaymentsTransfers.RealTimePaymentsTransfer.decode(body)}

      {:error, error} ->
        {:error, error}
    end
  end
end
