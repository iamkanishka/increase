defmodule Increase do
  @moduledoc """
  An idiomatic Elixir client for the [Increase API](https://increase.com),
  covering every resource: accounts, transfers (ACH, wire, check, RTP,
  FedNow, Swift), cards, entities, webhooks, and the sandbox simulation
  endpoints used for testing.

  ## Installation

  Add `:increase` to your `mix.exs` dependencies:

      def deps do
        [
          {:increase, "~> 1.0.0"}
        ]
      end

  ## Configuration

  Set your API key and environment in `config/config.exs` (or
  `config/runtime.exs` if you'd rather read it from the environment at
  boot):

      config :increase,
        api_key: System.fetch_env!("INCREASE_API_KEY"),
        environment: :sandbox # or :production

  Sign up at [dashboard.increase.com](https://dashboard.increase.com) to
  get sandbox and production API key pairs. In sandbox, no real money
  moves -- it's there so you can build and test your integration safely.

  If you'd rather not rely on application config (for example, if you're
  talking to multiple Increase accounts from one app), build a client
  explicitly and pass it as the first argument to any function instead:

      client = Increase.Client.new(api_key: "sandbox_...", environment: :sandbox)
      {:ok, account} = Increase.Accounts.retrieve(client, "account_in71c4amph0vgo2qllky")

  ## Usage

  Every resource lives in its own module, named to match the API docs --
  `Increase.Accounts`, `Increase.ACHTransfers`, `Increase.Cards`,
  `Increase.Events`, and so on. Each one exposes the operations available
  for that resource (`create/2`, `retrieve/2`, `update/3`, `list/2`, plus
  whatever resource-specific actions exist, like
  `Increase.CardDisputes.withdraw/2`).

      {:ok, account} =
        Increase.Accounts.create(client, %{name: "My First Account"})

      {:ok, account} =
        Increase.Accounts.retrieve(client, account["id"])

      {:ok, page} =
        Increase.Accounts.list(client, status: %{in: ["open"]})

  Every function returns `{:ok, result}` or `{:error, %Increase.Error{}}`
  -- there are no exceptions to rescue for ordinary API errors. See
  `Increase.Error` for the shape of API errors, and `Increase.Page` for
  how to page through list results (including lazy auto-pagination across
  every page with `Increase.Page.auto_paging_stream/1`).

  Mutating requests (`create/2`, `update/3`, and similar) accept an
  `idempotency_key:` option so you can safely retry them:

      Increase.ACHTransfers.create(
        client,
        %{account_id: "...", amount: 1000, ...},
        idempotency_key: "transfer-\#{order_id}"
      )

  For testing, see `Increase.Simulations` -- a whole family of sandbox-only
  endpoints that let you fast-forward events (settle a card authorization,
  receive an inbound wire, have the Federal Reserve acknowledge an ACH
  transfer) that would otherwise take hours or days to occur naturally.

  ## Webhooks

  If you've configured an Event Subscription, Increase will POST events to
  your endpoint as they happen. Verify these requests with
  `Increase.Webhook.verify/4` before trusting their contents:

      case Increase.Webhook.verify(raw_body, headers, signing_secret) do
        :ok -> handle_event(Jason.decode!(raw_body))
        {:error, reason} -> Logger.warning("Rejected webhook: \#{reason}")
      end

  See `Increase.Webhook` for the full guide, including how to extract the
  required headers from a `Plug.Conn`.

  ## Errors

  API errors are returned as `{:error, %Increase.Error{}}` and follow
  [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html): every error has
  a `type`, `title`, `status`, and optional `detail`. Transport-level
  failures (timeouts, DNS issues, etc) are normalized into the same
  struct with `type: "transport_error"`, so you only need to handle one
  shape.

      case Increase.Accounts.close(client, account_id) do
        {:ok, account} ->
          account

        {:error, %Increase.Error{type: "invalid_operation_error"} = error} ->
          Logger.warning("Could not close account: \#{error.detail}")

        {:error, error} ->
          raise error
      end
  """
end
