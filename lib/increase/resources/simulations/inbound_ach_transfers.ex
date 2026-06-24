defmodule Increase.Simulations.InboundACHTransfers do
  @moduledoc """
  Sandbox-only simulations related to Inbound ACH Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an inbound ACH transfer to your account. This imitates initiating
  a transfer to an Increase account from a different financial institution.
  The transfer may be either a credit or a debit depending on if the `amount`
  is positive or negative. The result of calling this API will contain the
  created transfer. You can pass a `resolve_at` parameter to allow for a
  window to [action on the Inbound ACH
  Transfer](https://increase.com/documentation/receiving-ach-transfers).
  Alternatively, if you don't pass the `resolve_at` parameter the result will
  contain either a [Transaction](#transactions) or a [Declined
  Transaction](#declined-transactions) depending on whether or not the
  transfer is allowed.

  `POST /simulations/inbound_ach_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.InboundACHTransfers.InboundACHTransfer.t()}
          | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_ach_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.InboundACHTransfers.InboundACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
