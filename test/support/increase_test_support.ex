defmodule Increase.TestSupport do
  @moduledoc """
  Helpers for building a `%Increase.Client{}` backed by `Req.Test` instead
  of a real HTTP connection, so resource module tests run fully offline
  and can assert on exactly what request was made.

  ## Usage

      defmodule MyTest do
        use ExUnit.Case, async: true
        import Increase.TestSupport

        setup :verify_on_exit!

        test "creates an account" do
          client = stub_client()

          Req.Test.stub(Increase.TestSupport, fn conn ->
            assert conn.method == "POST"
            assert conn.request_path == "/accounts"
            Req.Test.json(conn, %{"id" => "account_123", "name" => "Test"})
          end)

          assert {:ok, %Increase.Accounts.Account{id: "account_123"}} =
                   Increase.Accounts.create(client, %{name: "Test"})
        end
      end
  """

  @doc """
  Builds a client wired up to send every request through
  `Req.Test.stub(Increase.TestSupport, ...)`. Pair with `Req.Test.stub/2`
  in each test to control the response.

  Retry delays default to `0` so tests exercising retry behavior don't
  actually sleep. Pass any `Increase.Client.new/1` option (e.g.
  `retry: false`) to override the defaults for a specific test.
  """
  def stub_client(opts \\ []) do
    defaults = [
      api_key: "sandbox_test_key",
      environment: :sandbox,
      plug: {Req.Test, Increase.TestSupport},
      retry_delay: fn _attempt -> 0 end
    ]

    Increase.Client.new(Keyword.merge(defaults, opts))
  end

  @doc "Re-exported for convenience: `setup :verify_on_exit!` in callers."
  def verify_on_exit!(context \\ %{}), do: Req.Test.verify_on_exit!(context)
end
