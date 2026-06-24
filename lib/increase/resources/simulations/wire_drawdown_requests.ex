defmodule Increase.Simulations.WireDrawdownRequests do
  @moduledoc """
  Sandbox-only simulations related to Wire Drawdown Request.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates a Wire Drawdown Request being refused by the debtor.

  `POST /simulations/wire_drawdown_requests/{wire_drawdown_request_id}/refuse`
  """
  @spec refuse(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.WireDrawdownRequests.WireDrawdownRequest.t()}
          | {:error, Increase.Error.t()}
  def refuse(client, wire_drawdown_request_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/wire_drawdown_requests/#{wire_drawdown_request_id}/refuse"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.WireDrawdownRequests.WireDrawdownRequest.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates a Wire Drawdown Request being submitted to Fedwire.

  `POST /simulations/wire_drawdown_requests/{wire_drawdown_request_id}/submit`
  """
  @spec submit(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.WireDrawdownRequests.WireDrawdownRequest.t()}
          | {:error, Increase.Error.t()}
  def submit(client, wire_drawdown_request_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/wire_drawdown_requests/#{wire_drawdown_request_id}/submit"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.WireDrawdownRequests.WireDrawdownRequest.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
