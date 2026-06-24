defmodule Increase.Simulations.WireTransfers do
  @moduledoc """
  Sandbox-only simulations related to Wire Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the reversal of a [Wire Transfer](#wire-transfers) by the Federal
  Reserve due to error conditions. This will also create a
  [Transaction](#transaction) to account for the returned funds. This Wire
  Transfer must first have a `status` of `complete`.

  `POST /simulations/wire_transfers/{wire_transfer_id}/reverse`
  """
  @spec reverse(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.WireTransfers.WireTransfer.t()} | {:error, Increase.Error.t()}
  def reverse(client, wire_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/wire_transfers/#{wire_transfer_id}/reverse"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.WireTransfers.WireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates the submission of a [Wire Transfer](#wire-transfers) to the
  Federal Reserve. This transfer must first have a `status` of
  `pending_approval` or `pending_creating`.

  `POST /simulations/wire_transfers/{wire_transfer_id}/submit`
  """
  @spec submit(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.WireTransfers.WireTransfer.t()} | {:error, Increase.Error.t()}
  def submit(client, wire_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/wire_transfers/#{wire_transfer_id}/submit"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.WireTransfers.WireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
