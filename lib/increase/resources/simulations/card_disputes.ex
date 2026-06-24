defmodule Increase.Simulations.CardDisputes do
  @moduledoc """
  Sandbox-only simulations related to Card Dispute.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  After a [Card Dispute](#card-disputes) is created in production, the dispute
  will initially be in a `pending_user_submission_reviewing` state. Since no
  review or further action happens in sandbox, this endpoint simulates moving
  a Card Dispute through its various states.

  `POST /simulations/card_disputes/{card_dispute_id}/action`
  """
  @spec action(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Increase.CardDisputes.CardDispute.t()} | {:error, Increase.Error.t()}
  def action(client, card_dispute_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_disputes/#{card_dispute_id}/action"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.CardDisputes.CardDispute.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
