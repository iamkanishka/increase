defmodule Increase.Simulations.InboundCheckDeposits do
  @moduledoc """
  Sandbox-only simulations related to Inbound Check Deposit.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an Inbound Check Deposit against your account. This imitates
  someone depositing a check at their bank that was issued from your account.
  It may or may not be associated with a Check Transfer. Increase will
  evaluate the Inbound Check Deposit as we would in production and either
  create a Transaction or a Declined Transaction as a result. You can inspect
  the resulting Inbound Check Deposit object to see the result.

  `POST /simulations/inbound_check_deposits`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.InboundCheckDeposits.InboundCheckDeposit.t()}
          | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_check_deposits"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.InboundCheckDeposits.InboundCheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates an adjustment on an Inbound Check Deposit. The Inbound Check
  Deposit must have a `status` of `accepted`.

  `POST /simulations/inbound_check_deposits/{inbound_check_deposit_id}/adjustment`
  """
  @spec adjustment(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, Increase.InboundCheckDeposits.InboundCheckDeposit.t()}
          | {:error, Increase.Error.t()}
  def adjustment(client, inbound_check_deposit_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_check_deposits/#{inbound_check_deposit_id}/adjustment"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.InboundCheckDeposits.InboundCheckDeposit.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
