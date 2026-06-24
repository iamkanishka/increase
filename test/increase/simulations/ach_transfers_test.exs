defmodule Increase.Simulations.ACHTransfersTest do
  use ExUnit.Case, async: true
  import Increase.TestSupport

  alias Increase.ACHTransfers.ACHTransfer

  setup :verify_on_exit!

  describe "submit/2 (no params)" do
    test "POSTs with an empty body and decodes the response into an ACHTransfer" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.method == "POST"
        assert conn.request_path == "/simulations/ach_transfers/ach_transfer_123/submit"
        assert Req.Test.raw_body(conn) == ""
        Req.Test.json(conn, %{"id" => "ach_transfer_123", "status" => "submitted"})
      end)

      assert {:ok, %ACHTransfer{id: "ach_transfer_123", status: "submitted"}} =
               Increase.Simulations.ACHTransfers.submit(client, "ach_transfer_123")
    end
  end

  describe "settle/3 (with params)" do
    test "POSTs the given params as a JSON body and decodes the response" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.request_path == "/simulations/ach_transfers/ach_transfer_123/settle"
        assert conn.body_params == %{"inbound_funds_hold_behavior" => "release"}
        Req.Test.json(conn, %{"id" => "ach_transfer_123", "status" => "settled"})
      end)

      assert {:ok, %ACHTransfer{status: "settled"}} =
               Increase.Simulations.ACHTransfers.settle(client, "ach_transfer_123", %{
                 inbound_funds_hold_behavior: "release"
               })
    end
  end

  describe "return/3" do
    # `return` is just a regular function name in Elixir (there is no
    # `return` statement/keyword), so this is safe to define and call.
    test "is callable despite its name shadowing no special form" do
      client = stub_client()

      Req.Test.stub(Increase.TestSupport, fn conn ->
        assert conn.request_path == "/simulations/ach_transfers/ach_transfer_123/return"
        Req.Test.json(conn, %{"id" => "ach_transfer_123", "status" => "returned"})
      end)

      assert {:ok, %ACHTransfer{status: "returned"}} =
               Increase.Simulations.ACHTransfers.return(client, "ach_transfer_123")
    end
  end
end
