defmodule Increase.Simulations.CardAuthentications do
  @moduledoc """
  Sandbox-only simulations related to Card Authentication.

  These endpoints only work against the sandbox environment and let you
  fast-forward events that would otherwise take hours or days in production
  (settlement, acknowledgement, returns, and so on). See
  https://increase.com/documentation/api/overview#sandbox for details.
  """

  alias Increase.Client

  @doc """
  Simulates a Card Authentication attempt on a [Card](#cards). The attempt
  always results in a [Card Payment](#card_payments) being created, either
  with a status that allows further action or a terminal failed status.

  `POST /simulations/card_authentications`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Increase.CardPayments.CardPayment.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_authentications"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.CardPayments.CardPayment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates an attempt at a Card Authentication Challenge. This updates the
  `card_authentications` object under the [Card Payment](#card_payments). You
  can also attempt the challenge by navigating to
  https://dashboard.increase.com/card_authentication_simulation/:card_payment_id.

  `POST /simulations/card_authentications/{card_payment_id}/challenge_attempts`
  """
  @spec challenge_attempts(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, Increase.CardPayments.CardPayment.t()} | {:error, Increase.Error.t()}
  def challenge_attempts(client, card_payment_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_authentications/#{card_payment_id}/challenge_attempts"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Increase.CardPayments.CardPayment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Simulates starting a Card Authentication Challenge for an existing Card
  Authentication. This updates the `card_authentications` object under the
  [Card Payment](#card_payments). To attempt the challenge, use the
  `/simulations/card_authentications/:card_payment_id/challenge_attempts`
  endpoint or navigate to
  https://dashboard.increase.com/card_authentication_simulation/:card_payment_id.

  `POST /simulations/card_authentications/{card_payment_id}/challenges`
  """
  @spec challenges(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Increase.CardPayments.CardPayment.t()} | {:error, Increase.Error.t()}
  def challenges(client, card_payment_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/simulations/card_authentications/#{card_payment_id}/challenges"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Increase.CardPayments.CardPayment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
