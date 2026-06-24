defmodule Increase.Simulations.Exports do
  @moduledoc """
  Sandbox-only simulations related to Export.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Many exports are created by you via POST /exports or in the Dashboard. Some
  exports are created automatically by Increase. For example, tax documents
  are published once a year. In sandbox, you can trigger the arrival of an
  export that would normally only be created automatically via this
  simulation.

  `POST /simulations/exports`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.Exports.Export.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/exports"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.Exports.Export.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
