defmodule Increase.Simulations.EntityOnboardingSessions do
  @moduledoc """
  Sandbox-only simulations related to Entity Onboarding Session.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates the submission of an [Entity Onboarding
  Session](#entity-onboarding-sessions). This session must have a `status` of
  `active`. After submission, the session will transition to `expired` and a
  new Entity will be created.

  `POST /simulations/entity_onboarding_sessions/{entity_onboarding_session_id}/submit`
  """
  @spec submit(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.EntityOnboardingSessions.EntityOnboardingSession.t()}
          | {:error, Increase.Error.t()}
  def submit(client, entity_onboarding_session_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/entity_onboarding_sessions/#{entity_onboarding_session_id}/submit"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.EntityOnboardingSessions.EntityOnboardingSession.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
