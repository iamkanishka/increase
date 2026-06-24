# Increase

[![CI](https://github.com/iamkanishka/increase/actions/workflows/ci.yml/badge.svg)](https://github.com/iamkanishka/increase/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/increase.svg)](https://hex.pm/packages/increase)
[![Documentation](https://img.shields.io/badge/documentation-gray.svg)](https://hexdocs.pm/increase)

An idiomatic, unofficial Elixir client for the [Increase API](https://increase.com/documentation/api/overview) -- covering every resource (accounts, ACH/wire/check/RTP/FedNow/Swift transfers, cards, entities, webhooks) plus the full set of sandbox simulation endpoints used for testing.

Built on top of [Req](https://github.com/wojtekmach/req), with:

* **Typed structs** for every resource and nested object, decoded automatically (%Increase.Accounts.Account{}, not bare maps).
* **Automatic retries** on rate limiting and server errors, with safe, automatic idempotency keys for retried mutating requests.
* **:telemetry events** for every outgoing request, for logging/metrics/tracing.
* **Webhook signature verification** for incoming Increase webhooks.

> **Note:** This is a community-built client, not an official Increase SDK. Increase officially supports SDKs for TypeScript, Python, Go, Java, Ruby, PHP, Kotlin, and C#/.NET -- see their [GitHub org](https://github.com/increase). This package follows the same conventions as those SDKs, adapted to be idiomatic Elixir.

## Installation

Add :increase to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:increase, "~> 1.0.0"}
  ]
end
```

## Configuration

Sign up at [dashboard.increase.com](https://dashboard.increase.com) to get a sandbox and production API key pair. In sandbox, no real money moves -- it exists so you can build and test your integration safely before going live.

Configure your key and environment in config/config.exs (or config/runtime.exs):

elixir
config :increase,
  api_key: System.fetch_env!("INCREASE_API_KEY"),
  environment: :sandbox # or :production


Or build a client explicitly, useful if you're talking to more than one Increase account from the same app:

elixir
client = Increase.Client.new(api_key: "sandbox_...", environment: :sandbox)
{:ok, account} = Increase.Accounts.retrieve(client, "account_in71c4amph0vgo2qllky")


Every resource function accepts the client as its first argument, and will fall back to the application-config-based default client if you pass nil or omit it where the signature allows.

## Usage

Every resource lives in its own module named to match the Increase docs: Increase.Accounts, Increase.ACHTransfers, Increase.Cards, Increase.Entities, Increase.Events, and so on -- 56 in total. Each exposes create/2, retrieve/2, update/3, and list/2 where the API supports them, plus whatever resource-specific actions exist (Increase.CardDisputes.withdraw/2, Increase.Accounts.close/1, and the sandbox-only simulations described below).

```elixir
client = Increase.Client.new()

{:ok, %Increase.Accounts.Account{} = account} =
  Increase.Accounts.create(client, %{name: "My First Account"})

{:ok, account} =
  Increase.Accounts.retrieve(client, account.id)

{:ok, %Increase.Accounts.BalanceLookup{} = balance} =
  Increase.Accounts.balance(client, account.id)

balance.current_balance   #=> 0
```



Every response decodes into a typed struct matching the resource -- field names, nesting, and DateTime/Date parsing all match the real API shape, so your editor's autocomplete and Dialyzer both understand what you're working with. See [What's generated, what's hand-written](#whats-generated-whats-hand-written) below for how fields you haven't seen yet (polymorphic union types like a Transaction's source) are represented.

### Listing and pagination

list/2 returns {:ok, %Increase.Page{}}, with data containing decoded structs. Use it directly for one page:

```elixir
{:ok, page} = Increase.Accounts.list(client, limit: 50)
page.data        #=> [%Increase.Accounts.Account{id: "account_...", ...}, ...]
page.next_cursor #=> "v57w5d" | nil
```

...or lazily stream every result across every page:


```elixir
{:ok, page} = Increase.Transactions.list(client, account_id: account.id)

Increase.Page.auto_paging_stream(page)
|> Stream.each(&IO.inspect/1)
|> Stream.run()
```

Filters that nest in the API (like date ranges) are passed as nested maps and flattened into the dotted query format Increase expects automatically:

```elixir
Increase.Transactions.list(client, %{
  account_id: account.id,
  created_at: %{after: "2024-01-01T00:00:00Z", before: "2024-02-01T00:00:00Z"}
})
```
# => GET /transactions?account_id=...&created_at.after=...&created_at.before=...


### Retries and idempotency

Requests are retried automatically on rate limiting (HTTP 429), server errors (500/502/503/504), and transient transport failures (timeouts, connection refused), honoring the API's Retry-After header. This is safe for every HTTP method, including POST/PATCH: whenever retries are enabled, this client automatically attaches an Idempotency-Key to every mutating request that doesn't already have one, generated once before the first attempt and reused for every retry. Increase guarantees retrying a request with the same key returns the original result instead of creating a duplicate, so this can never double-create anything.

You can also pass your own idempotency key explicitly -- handy for de-duplicating requests across application restarts, not just within a single retry sequence:

```elixir
Increase.ACHTransfers.create(
  client,
  %{account_id: account.id, amount: 1000, ...},
  idempotency_key: "transfer-#{order_id}"
)
```

Retry behavior is just Req's own :retry option underneath, and can be reconfigured or disabled per-client:

```elixir
# Disable retries entirely:
Increase.Client.new(retry: false)

# Cap at 1 retry instead of the default:
Increase.Client.new(max_retries: 1)
```

### Telemetry

Every request emits :telemetry events under the [:increase, :request] prefix (:start, :stop, :exception), with :method, :path, and (on :stop) :status or :error in the metadata. See Increase.Client's moduledoc for the full event reference and an attach example.

### Errors

Every function returns {:ok, result} or {:error, %Increase.Error{}} -- no exceptions to rescue for ordinary API errors. Errors follow [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html) and always carry the same four fields: type, title, status, and a nullable detail.

```elixir
case Increase.Accounts.close(client, account_id) do
  {:ok, account} ->
    account

  {:error, %Increase.Error{type: "invalid_operation_error"} = error} ->
    Logger.warning("Could not close account: #{error.detail}")

  {:error, error} ->
    raise error
end
```

### Sandbox simulations

Increase.Simulations groups the sandbox-only endpoints that let you fast-forward events that would otherwise take hours or days in production -- settling a card authorization, having the Federal Reserve acknowledge an ACH transfer, receiving an inbound wire, and so on. These only work in the sandbox environment, and decode into the same structs as their production counterparts (simulating an ACH transfer settlement returns a regular %Increase.ACHTransfers.ACHTransfer{}, for example).

```elixir
{:ok, card} = Increase.Cards.create(client, %{account_id: account.id, ...})

{:ok, authorization} =
  Increase.Simulations.CardAuthorizations.create(client, %{
    card_id: card.id,
    amount: 1000
  })

{:ok, transfer} = Increase.ACHTransfers.create(client, %{...})
{:ok, _} = Increase.Simulations.ACHTransfers.submit(client, transfer.id)
{:ok, _} = Increase.Simulations.ACHTransfers.settle(client, transfer.id)
```

If you have a sandbox Event Subscription configured, triggering a simulation also fires the corresponding webhook to your endpoint, just as it would in production.

### Webhooks

Increase signs webhooks using the [Standard Webhooks](https://www.standardwebhooks.com/) specification. Verify a webhook's authenticity before trusting its contents, using the **raw, unparsed** request body:

```elixir
def webhook_controller_action(conn, _params) do
  {:ok, raw_body, conn} = Plug.Conn.read_body(conn)

  headers = %{
    "webhook-id" => List.first(Plug.Conn.get_req_header(conn, "webhook-id")),
    "webhook-timestamp" => List.first(Plug.Conn.get_req_header(conn, "webhook-timestamp")),
    "webhook-signature" => List.first(Plug.Conn.get_req_header(conn, "webhook-signature"))
  }

  case Increase.Webhook.verify(raw_body, headers, signing_secret()) do
    :ok ->
      event = Jason.decode!(raw_body)
      handle_event(event)
      Plug.Conn.send_resp(conn, 200, "")

    {:error, reason} ->
      Plug.Conn.send_resp(conn, 400, "invalid signature: #{reason}")
  end
end
```

verify/4 checks both the HMAC-SHA256 signature and that the timestamp is within a tolerance window (5 minutes by default), to protect against replay attacks. See Increase.Webhook for the full reference.

## What's generated, what's hand-written

The 56 resource modules under Increase.* and the 35 submodules under Increase.Simulations.* -- including their typed structs -- were generated from the endpoint and struct definitions in Increase's official [Go SDK](https://github.com/increase/increase-go) source, to keep paths, parameters, field types, and documentation accurate and in sync with the real API surface. The core client (Increase.Client), error handling (Increase.Error), pagination (Increase.Page), decoding helpers (Increase.Decode), and webhook verification (Increase.Webhook) are hand-written.

A few design choices worth knowing about:

* Functions are named after the underlying action where there's a clear convention (create, retrieve, update, list); resource-specific actions keep their literal name from the API (submit, settle, withdraw, return, etc), even where that occasionally collides with a word that has special meaning elsewhere in Elixir (return is just a regular function name here -- Elixir has no return statement, so this is safe to call).
* Struct fields that the Go SDK represents as one-of-many possible nested objects gated by a category/type discriminator (for example, a Transaction's source, which can be exactly one of ~36 different shapes depending on source.category) are decoded as plain maps rather than one struct per variant. Each such field's docs enumerate every possible shape, so you know what to pattern-match on; this avoids generating dozens of near-identical structs per resource whose only real use is reading a couple of fields after checking the discriminator.
* A handful of generated files contain very long single-line defstruct/@type t :: declarations (some resources have 30+ fields). Run mix format once after installing/cloning if you want these wrapped to your configured line length -- it's idempotent and safe.

## Development

```sh
git clone https://github.com/iamkanishka/increase.git
cd increase
mix setup
mix check    # format check + credo + dialyzer + audit + test
```

 

This package targets Elixir ~> 1.15 (tested against Elixir 1.15-1.20 / Erlang OTP 25-28 in CI) and Req ~> 0.5 (tested against the Plug.Parsers-based request body handling introduced in Req v0.5.11 -- tests assert on conn.body_params / Req.Test.raw_body/1 rather than calling Plug.Conn.read_body/1 directly inside Req.Test stubs, since that call returns "" as of that version).

## License

MIT. Not affiliated with or endorsed by Increase Technologies, Inc.
