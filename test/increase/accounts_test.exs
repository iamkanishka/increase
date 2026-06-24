defmodule Increase.AccountsTest do
  use ExUnit.Case, async: true
  import Increase.TestSupport

  alias Increase.Accounts.Account
  alias Increase.Accounts.BalanceLookup

  setup :verify_on_exit!

  describe "create/2" do
    test "POSTs to /accounts with the given params and decodes the response into an Account" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.method == "POST"
        assert conn.request_path == "/accounts"
        assert conn.body_params == %{"name" => "My First Account"}

        Req.Test.json(conn, %{
          "id" => "account_123",
          "name" => "My First Account",
          "status" => "open",
          "created_at" => "2024-01-01T12:00:00Z",
          "loan" => nil
        })
      end)

      assert {:ok, %Account{} = account} =
               Increase.Accounts.create(client, %{name: "My First Account"})

      assert account.id == "account_123"
      assert account.name == "My First Account"
      assert account.status == "open"
      assert account.created_at == ~U[2024-01-01 12:00:00Z]
      assert account.loan == nil
    end

    test "forwards an idempotency_key option as a header" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert ["create-acct-1"] = Plug.Conn.get_req_header(conn, "idempotency-key")
        Req.Test.json(conn, %{"id" => "account_123"})
      end)

      assert {:ok, %Account{id: "account_123"}} =
               Increase.Accounts.create(client, %{name: "x"}, idempotency_key: "create-acct-1")
    end

    test "decodes a nested loan object into Account.Loan" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        Req.Test.json(conn, %{
          "id" => "account_123",
          "loan" => %{
            "credit_limit" => 500_000,
            "grace_period_days" => 25,
            "maturity_date" => "2030-01-01",
            "statement_day_of_month" => 1,
            "statement_payment_type" => "balance"
          }
        })
      end)

      assert {:ok, %Account{loan: %Account.Loan{} = loan}} =
               Increase.Accounts.create(client, %{name: "x"})

      assert loan.credit_limit == 500_000
      assert loan.maturity_date == ~D[2030-01-01]
      assert loan.statement_payment_type == "balance"
    end
  end

  describe "retrieve/2" do
    test "GETs /accounts/{id} with no body" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.method == "GET"
        assert conn.request_path == "/accounts/account_123"
        Req.Test.json(conn, %{"id" => "account_123", "status" => "open"})
      end)

      assert {:ok, %Account{status: "open"}} = Increase.Accounts.retrieve(client, "account_123")
    end
  end

  describe "update/3" do
    test "PATCHes /accounts/{id} with the given params" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.method == "PATCH"
        assert conn.request_path == "/accounts/account_123"
        assert conn.body_params == %{"name" => "Renamed"}
        Req.Test.json(conn, %{"id" => "account_123", "name" => "Renamed"})
      end)

      assert {:ok, %Account{name: "Renamed"}} =
               Increase.Accounts.update(client, "account_123", %{name: "Renamed"})
    end
  end

  describe "list/2" do
    test "GETs /accounts with filters flattened into the query string, decoding each item" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.method == "GET"
        assert conn.request_path == "/accounts"
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params["limit"] == "2"

        Req.Test.json(conn, %{
          "data" => [%{"id" => "account_1"}, %{"id" => "account_2"}],
          "next_cursor" => nil
        })
      end)

      assert {:ok, %Increase.Page{data: data, next_cursor: nil}} =
               Increase.Accounts.list(client, %{limit: 2})

      assert [%Account{id: "account_1"}, %Account{id: "account_2"}] = data
    end

    test "the returned page's fetch_next requests the next cursor and decodes subsequent pages too" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)

        case conn.query_params["cursor"] do
          nil ->
            Req.Test.json(conn, %{"data" => [%{"id" => "account_1"}], "next_cursor" => "abc"})

          "abc" ->
            Req.Test.json(conn, %{"data" => [%{"id" => "account_2"}], "next_cursor" => nil})
        end
      end)

      assert {:ok, page} = Increase.Accounts.list(client)
      assert page.next_cursor == "abc"

      assert Increase.Page.auto_paging_stream(page) |> Enum.map(& &1.id) == [
               "account_1",
               "account_2"
             ]
    end
  end

  describe "balance/3" do
    test "GETs /accounts/{id}/balance, forwards an at_time query param, and decodes a BalanceLookup" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.request_path == "/accounts/account_123/balance"
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params["at_time"] == "2024-01-01T00:00:00Z"

        Req.Test.json(conn, %{
          "account_id" => "account_123",
          "current_balance" => 1000,
          "available_balance" => 900,
          "type" => "balance_lookup",
          "loan" => nil
        })
      end)

      assert {:ok, %BalanceLookup{} = balance} =
               Increase.Accounts.balance(client, "account_123", %{
                 at_time: "2024-01-01T00:00:00Z"
               })

      assert balance.current_balance == 1000
      assert balance.available_balance == 900
    end
  end

  describe "close/2" do
    test "POSTs to /accounts/{id}/close with no body" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.method == "POST"
        assert conn.request_path == "/accounts/account_123/close"
        Req.Test.json(conn, %{"id" => "account_123", "status" => "closed"})
      end)

      assert {:ok, %Account{status: "closed"}} = Increase.Accounts.close(client, "account_123")
    end

    test "surfaces an insufficient-balance error as %Increase.Error{}" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        conn
        |> Plug.Conn.put_status(409)
        |> Req.Test.json(%{
          "type" => "invalid_operation_error",
          "title" =>
            "The action you specified can't be performed on the object in its current state.",
          "status" => 409,
          "detail" => "There's an insufficient balance in the account."
        })
      end)

      assert {:error, %Increase.Error{type: "invalid_operation_error", status: 409}} =
               Increase.Accounts.close(client, "account_with_balance")
    end
  end
end
