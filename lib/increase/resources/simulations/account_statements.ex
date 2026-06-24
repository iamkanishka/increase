defmodule Increase.Simulations.AccountStatements do
  @moduledoc """
  Sandbox-only simulations related to Account Statement.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an [Account Statement](#account-statements) being created for an
  account. In production, Account Statements are generated once per month.

  `POST /simulations/account_statements`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.AccountStatements.AccountStatement.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/account_statements"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.AccountStatements.AccountStatement.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
