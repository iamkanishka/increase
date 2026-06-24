defmodule Increase.Simulations.Entities do
  @moduledoc """
  Sandbox-only simulations related to Entity.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulate updates to an [Entity's
  validation]. In
  production, Know Your Customer validations [run
  automatically] for
  eligible programs. While developing, use this API to simulate issues with
  information submissions.

  `POST /simulations/entities/{entity_id}/update_validation`
  """
  @spec update_validation(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, Increase.Entities.Entity.t()} | {:error, Increase.Error.t()}
  def update_validation(client, entity_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/entities/#{entity_id}/update_validation"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.Entities.Entity.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
