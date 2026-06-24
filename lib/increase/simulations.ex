defmodule Increase.Simulations do
  @moduledoc """
  Sandbox-only endpoints for simulating events that would otherwise take
  hours or days to occur in production -- settling a card authorization,
  receiving an inbound wire, having the Federal Reserve acknowledge an ACH
  transfer, and so on.

  These only work against the sandbox environment (the default
  environment unless you configure `:production`). If you have a sandbox
  Event Subscription configured, triggering a simulation will also fire
  the corresponding webhook to your endpoint, just as the real event
  would in production.

  Each simulate-able resource has its own submodule here, named after the
  resource it relates to:

    * `Increase.Simulations.AccountRevenuePayments`
    * `Increase.Simulations.AccountStatements`
    * `Increase.Simulations.ACHTransfers`
    * `Increase.Simulations.CardAuthentications`
    * `Increase.Simulations.CardAuthorizationExpirations`
    * `Increase.Simulations.CardAuthorizations`
    * `Increase.Simulations.CardBalanceInquiries`
    * `Increase.Simulations.CardDisputes`
    * `Increase.Simulations.CardFuelConfirmations`
    * `Increase.Simulations.CardIncrements`
    * `Increase.Simulations.CardPurchaseSupplements`
    * `Increase.Simulations.CardRefunds`
    * `Increase.Simulations.CardReversals`
    * `Increase.Simulations.CardSettlements`
    * `Increase.Simulations.CardTokens`
    * `Increase.Simulations.CheckDeposits`
    * `Increase.Simulations.CheckTransfers`
    * `Increase.Simulations.DigitalWalletTokenRequests`
    * `Increase.Simulations.Entities`
    * `Increase.Simulations.EntityOnboardingSessions`
    * `Increase.Simulations.Exports`
    * `Increase.Simulations.InboundACHTransfers`
    * `Increase.Simulations.InboundCheckDeposits`
    * `Increase.Simulations.InboundFednowTransfers`
    * `Increase.Simulations.InboundMailItems`
    * `Increase.Simulations.InboundRealTimePaymentsTransfers`
    * `Increase.Simulations.InboundWireDrawdownRequests`
    * `Increase.Simulations.InboundWireTransfers`
    * `Increase.Simulations.InterestPayments`
    * `Increase.Simulations.PendingTransactions`
    * `Increase.Simulations.PhysicalCards`
    * `Increase.Simulations.Programs`
    * `Increase.Simulations.RealTimePaymentsTransfers`
    * `Increase.Simulations.WireDrawdownRequests`
    * `Increase.Simulations.WireTransfers`

  ## Example

      client = Increase.Client.new(environment: :sandbox)

      {:ok, account} = Increase.Accounts.create(client, %{name: "My First Account"})

      {:ok, authorization} =
        Increase.Simulations.CardAuthorizations.create(client, %{
          card_id: card.id,
          amount: 1000
        })
  """
end
