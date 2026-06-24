defmodule Increase.ClientTest do
  use ExUnit.Case, async: true
  import Increase.TestSupport

  setup :verify_on_exit!

  describe "new/1" do
    test "defaults to the sandbox base url" do
      client = Increase.Client.new(api_key: "sandbox_123")
      assert client.base_url == "https://sandbox.increase.com"
    end

    test "uses the production base url when environment: :production" do
      client = Increase.Client.new(api_key: "key_123", environment: :production)
      assert client.base_url == "https://api.increase.com"
    end

    test "an explicit :base_url overrides :environment" do
      client =
        Increase.Client.new(
          api_key: "key_123",
          environment: :production,
          base_url: "http://localhost:4000"
        )

      assert client.base_url == "http://localhost:4000"
    end

    test "reads api_key from application config when not passed explicitly" do
      Application.put_env(:increase, :api_key, "configured_key")
      on_exit(fn -> Application.delete_env(:increase, :api_key) end)

      client = Increase.Client.new()
      assert client.api_key == "configured_key"
    end
  end

  describe "resolve/1" do
    test "passes an existing client through unchanged" do
      client = Increase.Client.new(api_key: "abc")
      assert Increase.Client.resolve(client) == client
    end

    test "builds a client from a keyword list" do
      client = Increase.Client.resolve(api_key: "from_keyword", environment: :production)
      assert client.api_key == "from_keyword"
      assert client.base_url == "https://api.increase.com"
    end

    test "builds the default client from nil" do
      Application.put_env(:increase, :api_key, "default_key")
      on_exit(fn -> Application.delete_env(:increase, :api_key) end)

      client = Increase.Client.resolve(nil)
      assert client.api_key == "default_key"
    end
  end

  describe "request/4" do
    test "sends a bearer authorization header" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert ["Bearer sandbox_test_key"] = Plug.Conn.get_req_header(conn, "authorization")
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, %{"ok" => true}} = Increase.Client.request(client, :get, "/accounts")
    end

    test "sends an idempotency-key header when given" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert ["retry-me-123"] = Plug.Conn.get_req_header(conn, "idempotency-key")
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} =
               Increase.Client.request(client, :post, "/accounts",
                 body: %{name: "x"},
                 idempotency_key: "retry-me-123"
               )
    end

    test "auto-generates an idempotency key for POST when none is given and retries are enabled" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert [key] = Plug.Conn.get_req_header(conn, "idempotency-key")
        assert key =~ ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} = Increase.Client.request(client, :post, "/accounts", body: %{name: "x"})
    end

    test "auto-generates an idempotency key for PATCH but not for GET" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} = Increase.Client.request(client, :get, "/accounts")
      # GET requests never carry an idempotency key -- already covered by
      # the "omits the idempotency-key header" test below, this just
      # confirms PATCH gets one the same way POST does.

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert [_key] = Plug.Conn.get_req_header(conn, "idempotency-key")
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} =
               Increase.Client.request(client, :patch, "/accounts/x", body: %{name: "y"})
    end

    test "does NOT auto-generate an idempotency key when retries are disabled" do
      client = stub_client(retry: false)

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert [] = Plug.Conn.get_req_header(conn, "idempotency-key")
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} = Increase.Client.request(client, :post, "/accounts", body: %{name: "x"})
    end

    test "an explicitly-given idempotency key is never overridden by auto-generation" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert ["mine"] = Plug.Conn.get_req_header(conn, "idempotency-key")
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} =
               Increase.Client.request(client, :post, "/accounts",
                 body: %{name: "x"},
                 idempotency_key: "mine"
               )
    end

    test "omits the idempotency-key header when not given" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert [] = Plug.Conn.get_req_header(conn, "idempotency-key")
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} = Increase.Client.request(client, :get, "/accounts")
    end

    test "flattens nested query params into dotted keys" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params["created_at.after"] == "2024-01-01T00:00:00Z"
        assert conn.query_params["created_at.before"] == "2024-02-01T00:00:00Z"
        Req.Test.json(conn, %{"data" => [], "next_cursor" => nil})
      end)

      assert {:ok, _} =
               Increase.Client.request(client, :get, "/transactions",
                 query: %{
                   created_at: %{after: "2024-01-01T00:00:00Z", before: "2024-02-01T00:00:00Z"}
                 }
               )
    end

    test "joins list query params with commas" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params["status.in"] == "open,closed"
        Req.Test.json(conn, %{"data" => [], "next_cursor" => nil})
      end)

      assert {:ok, _} =
               Increase.Client.request(client, :get, "/accounts",
                 query: %{status: %{in: ["open", "closed"]}}
               )
    end

    test "returns {:error, %Increase.Error{}} for a non-2xx RFC 9457 response" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        conn
        |> Plug.Conn.put_status(409)
        |> Req.Test.json(%{
          "type" => "invalid_operation_error",
          "title" => "The action you specified can't be performed.",
          "status" => 409,
          "detail" => "There's an insufficient balance in the account."
        })
      end)

      assert {:error, %Increase.Error{} = error} =
               Increase.Client.request(client, :post, "/accounts/x/close")

      assert error.type == "invalid_operation_error"
      assert error.status == 409
      assert error.detail == "There's an insufficient balance in the account."
    end
  end

  describe "retries" do
    test "retries a GET on a 503 and succeeds once the server recovers" do
      client = stub_client()

      Req.Test.expect(Increase.TestSupport, fn conn ->
        Plug.Conn.send_resp(conn, 503, "")
      end)

      Req.Test.expect(Increase.TestSupport, fn conn ->
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, %{"ok" => true}} = Increase.Client.request(client, :get, "/accounts")
    end

    test "retries a POST on a 429 using the SAME auto-generated idempotency key every attempt" do
      client = stub_client()

      {:ok, agent} = Agent.start_link(fn -> [] end)

      Req.Test.stub(Increase.TestSupport, fn conn ->
        [key] = Plug.Conn.get_req_header(conn, "idempotency-key")
        attempt = Agent.get_and_update(agent, fn keys -> {length(keys) + 1, [key | keys]} end)

        if attempt < 2 do
          Plug.Conn.send_resp(conn, 429, "")
        else
          Req.Test.json(conn, %{"ok" => true})
        end
      end)

      assert {:ok, %{"ok" => true}} =
               Increase.Client.request(client, :post, "/accounts", body: %{name: "x"})

      keys = Agent.get(agent, & &1)
      assert length(keys) == 2
      assert length(Enum.uniq(keys)) == 1
    end

    test "does not retry a non-retryable 4xx response" do
      client = stub_client()

      Req.Test.expect(Increase.TestSupport, fn conn ->
        conn
        |> Plug.Conn.put_status(422)
        |> Req.Test.json(%{
          "type" => "invalid_parameters_error",
          "title" => "Invalid parameters",
          "status" => 422,
          "detail" => nil
        })
      end)

      assert {:error, %Increase.Error{status: 422}} =
               Increase.Client.request(client, :post, "/accounts", body: %{name: "x"})
    end

    test "respects retry: false and never retries, even on a 503" do
      client = stub_client(retry: false)

      Req.Test.expect(Increase.TestSupport, fn conn ->
        Plug.Conn.send_resp(conn, 503, "")
      end)

      assert {:error, %Increase.Error{status: 503}} =
               Increase.Client.request(client, :get, "/accounts")
    end
  end

  describe "telemetry" do
    setup do
      events = []
      {:ok, agent} = Agent.start_link(fn -> events end)

      handler_id = "client-test-#{System.unique_integer()}"

      :telemetry.attach_many(
        handler_id,
        [
          [:increase, :request, :start],
          [:increase, :request, :stop],
          [:increase, :request, :exception]
        ],
        fn event, measurements, metadata, _config ->
          Agent.update(agent, fn evts -> [{event, measurements, metadata} | evts] end)
        end,
        nil
      )

      on_exit(fn -> :telemetry.detach(handler_id) end)

      %{agent: agent}
    end

    test "emits start and stop events with method/path metadata on success", %{agent: agent} do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        Req.Test.json(conn, %{"ok" => true})
      end)

      assert {:ok, _} = Increase.Client.request(client, :get, "/accounts")

      events = Agent.get(agent, &Enum.reverse/1)

      assert [
               {[:increase, :request, :start], start_meas, start_meta},
               {[:increase, :request, :stop], stop_meas, stop_meta}
             ] = events

      assert start_meta.method == :get
      assert start_meta.path == "/accounts"
      assert is_integer(start_meas.system_time)

      assert stop_meta.method == :get
      assert stop_meta.path == "/accounts"
      assert is_integer(stop_meas.duration)
    end

    test "includes :status in stop metadata for an API error response", %{agent: agent} do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        conn
        |> Plug.Conn.put_status(409)
        |> Req.Test.json(%{
          "type" => "invalid_operation_error",
          "title" => "x",
          "status" => 409,
          "detail" => nil
        })
      end)

      assert {:error, _} = Increase.Client.request(client, :post, "/accounts/x/close")

      events = Agent.get(agent, &Enum.reverse/1)
      assert [_start, {[:increase, :request, :stop], _meas, stop_meta}] = events
      assert stop_meta.status == 409
    end
  end
end
