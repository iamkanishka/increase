defmodule Increase.Simulations.InboundMailItems do
  @moduledoc """
  Sandbox-only simulations related to Inbound Mail Item.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates an Inbound Mail Item to one of your Lockbox Addresses or Lockbox
  Recipients, as if someone had mailed a physical check.

  `POST /simulations/inbound_mail_items`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.InboundMailItems.InboundMailItem.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/inbound_mail_items"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.InboundMailItems.InboundMailItem.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
