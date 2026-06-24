defmodule Increase.Simulations.CheckDeposits do
  @moduledoc """
  Sandbox-only simulations related to Check Deposit.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the creation of a [Check Deposit
  Adjustment](#check-deposit-adjustments) on a [Check
  Deposit](#check-deposits). This Check Deposit must first have a `status` of
  `submitted`.

  `POST /simulations/check_deposits/{check_deposit_id}/adjustment`
  """
  @spec adjustment(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, Increase.CheckDeposits.CheckDeposit.t()} | {:error, Increase.Error.t()}
  def adjustment(client, check_deposit_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/check_deposits/#{check_deposit_id}/adjustment"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.CheckDeposits.CheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates the rejection of a [Check Deposit](#check-deposits) by Increase
  due to factors like poor image quality. This Check Deposit must first have a
  `status` of `pending`.

  `POST /simulations/check_deposits/{check_deposit_id}/reject`
  """
  @spec reject(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.CheckDeposits.CheckDeposit.t()} | {:error, Increase.Error.t()}
  def reject(client, check_deposit_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/check_deposits/#{check_deposit_id}/reject"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.CheckDeposits.CheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates the return of a [Check Deposit](#check-deposits). This Check
  Deposit must first have a `status` of `submitted`.

  `POST /simulations/check_deposits/{check_deposit_id}/return`
  """
  @spec return(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.CheckDeposits.CheckDeposit.t()} | {:error, Increase.Error.t()}
  def return(client, check_deposit_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/check_deposits/#{check_deposit_id}/return"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.CheckDeposits.CheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates the submission of a [Check Deposit](#check-deposits) to the
  Federal Reserve. This Check Deposit must first have a `status` of `pending`.

  `POST /simulations/check_deposits/{check_deposit_id}/submit`
  """
  @spec submit(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Increase.CheckDeposits.CheckDeposit.t()} | {:error, Increase.Error.t()}
  def submit(client, check_deposit_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/check_deposits/#{check_deposit_id}/submit"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.CheckDeposits.CheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
