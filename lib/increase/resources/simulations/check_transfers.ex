defmodule Increase.Simulations.CheckTransfers do
  @moduledoc """
  Sandbox-only simulations related to Check Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the mailing of a [Check Transfer](#check-transfers), which happens
  periodically throughout the day in production but can be sped up in sandbox.
  This transfer must first have a `status` of `pending_approval` or
  `pending_submission`.

  `POST /simulations/check_transfers/{check_transfer_id}/mail`
  """
  @spec mail(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.CheckTransfers.CheckTransfer.t()} | {:error, Increase.Error.t()}
  def mail(client, check_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/check_transfers/#{check_transfer_id}/mail"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.CheckTransfers.CheckTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
