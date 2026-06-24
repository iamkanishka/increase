# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - Unreleased

Initial release.

### Added

- Full coverage of the Increase API: 56 resources (Accounts, ACH/Wire/Check/RTP/FedNow/Swift
  Transfers, Cards, Entities, Events, and more) across 190 endpoints, plus all 48 sandbox
  simulation endpoints under `Increase.Simulations`.
- Typed structs for every resource and nested object (e.g. `%Increase.Accounts.Account{}`),
  generated with accurate `@type` specs, including `DateTime`/`Date` parsing for timestamp
  fields. Deeply polymorphic union fields (like a Transaction's `source`) are represented as
  plain, well-documented maps rather than dozens of near-identical generated structs.
- `Increase.Client` -- configuration, request building, and dispatch, with:
  - Automatic retries on rate limiting (429) and server errors (500/502/503/504), honoring
    `Retry-After`, built on `Req`'s own retry mechanism.
  - Automatic `Idempotency-Key` generation for retried `POST`/`PATCH` requests that don't
    already have one, so retries are always safe.
  - `:telemetry` events (`[:increase, :request, :start | :stop | :exception]`) for every
    outgoing request.
- `Increase.Page` for cursor-based pagination, with `auto_paging_stream/1` and
  `auto_paging_each/2` for walking every page lazily.
- `Increase.Error` -- RFC 9457-shaped API errors and transport failures normalized into one
  struct.
- `Increase.Webhook` -- Standard Webhooks signature verification (HMAC-SHA256) for incoming
  Increase webhooks, with replay-attack timestamp tolerance checking.

[1.0.0]: https://github.com/iamkanishka/increase/releases/tag/v1.0.0
