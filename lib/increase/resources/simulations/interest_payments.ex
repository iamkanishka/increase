defmodule Increase.Simulations.InterestPayments do
  @moduledoc """
  Sandbox-only simulations related to Interest Payment.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an interest payment to your account. In production, this happens
  automatically on the first of each month.

  `POST /simulations/interest_payments`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.Transactions.Transaction.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/interest_payments"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.Transactions.Transaction.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
