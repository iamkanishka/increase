defmodule Increase.MixProject do
  use Mix.Project

  @source_url "https://github.com/iamkanishka/increase"
  @version "1.0.0"

  def project do
    [
      app: :increase,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Increase",
      source_url: @source_url,
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        dialyzer: :test
      ],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_apps: [:mix],
        flags: [:error_handling, :unknown]
      ],
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:req, "~> 0.5"},
      {:jason, "~> 1.4"},
      {:telemetry, "~> 1.0"},
      {:plug, "~> 1.0", only: :test},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    "An idiomatic Elixir client for the Increase API (https://increase.com) -- " <>
      "modern bank infrastructure for storing, moving, and reconciling money."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib mix.exs README.md LICENSE CHANGELOG.md)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md", "LICENSE"],
      source_ref: "v#{@version}",
      source_url: @source_url,
      nest_modules_by_prefix: resource_module_prefixes(),
      groups_for_modules: [
        "Getting started": [
          Increase,
          Increase.Client,
          Increase.Error,
          Increase.Page,
          Increase.Webhook,
          Increase.Decode
        ],
        Simulations: ~r/^Increase\.Simulations\./,
        Resources:
          ~r/^Increase\.(?!Client$|Error$|Page$|Webhook$|Decode$|Simulations(\.|$))[A-Za-z]+(\..+)?$/
      ]
    ]
  end

  # Every Increase.<Resource> module name, used so ExDoc nests that
  # resource's struct submodules (Increase.Accounts.Account and so on)
  # under it in the sidebar instead of listing 90+ modules flat.
  defp resource_module_prefixes do
    ~w(
      ACHPrenotifications ACHTransfers AccountNumbers AccountStatements
      AccountTransfers Accounts BeneficialOwners CardDisputes CardPayments
      CardPurchaseSupplements CardPushTransfers CardTokens CardValidations
      Cards CheckDeposits CheckTransfers DeclinedTransactions
      DigitalCardProfiles DigitalWalletTokens Entities
      EntityOnboardingSessions EventSubscriptions Events Exports
      ExternalAccounts FednowTransfers FileLinks Files Groups
      InboundACHTransfers InboundCheckDeposits InboundFednowTransfers
      InboundMailItems InboundRealTimePaymentsTransfers
      InboundWireDrawdownRequests InboundWireTransfers
      IntrafiAccountEnrollments IntrafiBalances IntrafiExclusions
      LockboxAddresses LockboxRecipients OAuthApplications OAuthConnections
      OAuthTokens PendingTransactions PhysicalCardProfiles PhysicalCards
      Programs RealTimeDecisions RealTimePaymentsTransfers RoutingNumbers
      SupplementalDocuments SwiftTransfers Transactions
      WireDrawdownRequests WireTransfers
    )
    |> Enum.map(&Module.concat(Increase, &1))
  end

  defp aliases do
    [
      setup: ["deps.get", "dialyzer --plt"],
      check: ["format --check-formatted", "credo --strict", "dialyzer", "deps.audit", "test"],
      "test.coverage": ["coveralls.html"]
    ]
  end
end
