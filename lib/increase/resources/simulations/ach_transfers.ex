defmodule Increase.Simulations.ACHTransfers do
  @moduledoc """
  Sandbox-only simulations related to ACH Transfer.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the acknowledgement of an [ACH Transfer](#ach-transfers) by the
  Federal Reserve. This transfer must first have a `status` of `submitted`. In
  production, the Federal Reserve generally acknowledges submitted ACH files
  within 30 minutes. Since sandbox ACH Transfers are not submitted to the
  Federal Reserve, this endpoint allows you to skip that delay and add the
  acknowledgement subresource to the ACH Transfer.

  `POST /simulations/ach_transfers/{ach_transfer_id}/acknowledge`
  """
  @spec acknowledge(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.ACHTransfers.ACHTransfer.t()} | {:error, Increase.Error.t()}
  def acknowledge(client, ach_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/ach_transfers/#{ach_transfer_id}/acknowledge"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.ACHTransfers.ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates receiving a Notification of Change for an [ACH
  Transfer](#ach-transfers).

  `POST /simulations/ach_transfers/{ach_transfer_id}/create_notification_of_change`
  """
  @spec new_notification_of_change(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, Increase.ACHTransfers.ACHTransfer.t()} | {:error, Increase.Error.t()}
  def new_notification_of_change(client, ach_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/ach_transfers/#{ach_transfer_id}/create_notification_of_change"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.ACHTransfers.ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates the return of an [ACH Transfer](#ach-transfers) by the Federal
  Reserve due to an error condition. This will also create a Transaction to
  account for the returned funds. This transfer must first have a `status` of
  `submitted`.

  `POST /simulations/ach_transfers/{ach_transfer_id}/return`
  """
  @spec return(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Increase.ACHTransfers.ACHTransfer.t()} | {:error, Increase.Error.t()}
  def return(client, ach_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/ach_transfers/#{ach_transfer_id}/return"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.ACHTransfers.ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates the settlement of an [ACH Transfer](#ach-transfers) by the Federal
  Reserve. This transfer must first have a `status` of `pending_submission` or
  `submitted`. For convenience, if the transfer is in `status`:
  `pending_submission`, the simulation will also submit the transfer. Without
  this simulation the transfer will eventually settle on its own following the
  same Federal Reserve timeline as in production. Additionally, you can
  specify the behavior of the inbound funds hold that is created when the ACH
  Transfer is settled. If no behavior is specified, the inbound funds hold
  will be released immediately in order for the funds to be available for use.

  `POST /simulations/ach_transfers/{ach_transfer_id}/settle`
  """
  @spec settle(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Increase.ACHTransfers.ACHTransfer.t()} | {:error, Increase.Error.t()}
  def settle(client, ach_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/ach_transfers/#{ach_transfer_id}/settle"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.ACHTransfers.ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates the submission of an [ACH Transfer](#ach-transfers) to the Federal
  Reserve. This transfer must first have a `status` of `pending_approval` or
  `pending_submission`. In production, Increase submits ACH Transfers to the
  Federal Reserve three times per day on weekdays. Since sandbox ACH Transfers
  are not submitted to the Federal Reserve, this endpoint allows you to skip
  that delay and transition the ACH Transfer to a status of `submitted`.

  `POST /simulations/ach_transfers/{ach_transfer_id}/submit`
  """
  @spec submit(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.ACHTransfers.ACHTransfer.t()} | {:error, Increase.Error.t()}
  def submit(client, ach_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/ach_transfers/#{ach_transfer_id}/submit"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.ACHTransfers.ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
