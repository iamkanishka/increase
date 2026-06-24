defmodule Increase.Simulations.PendingTransactions do
  @moduledoc """
  Sandbox-only simulations related to Pending Transaction.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  This endpoint simulates immediately releasing an Inbound Funds Hold, which
  might be created as a result of, for example, an ACH debit.

  `POST /simulations/pending_transactions/{pending_transaction_id}/release_inbound_funds_hold`
  """
  @spec release_inbound_funds_hold(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.PendingTransactions.PendingTransaction.t()}
          | {:error, Increase.Error.t()}
  def release_inbound_funds_hold(client, pending_transaction_id, opts \\ []) do
    client = Client.resolve(client)

    path =
      "/simulations/pending_transactions/#{pending_transaction_id}/release_inbound_funds_hold"

    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.PendingTransactions.PendingTransaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
