defmodule Increase.Simulations.Programs do
  @moduledoc """
  Sandbox-only simulations related to Program.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates a [Program](#programs) being created in your group. By default,
  your group has one program called Commercial Banking. Note that when your
  group operates more than one program, `program_id` is a required field when
  creating accounts.

  `POST /simulations/programs`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.Programs.Program.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/programs"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.Programs.Program.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
