defmodule Increase.ErrorTest do
  use ExUnit.Case, async: true

  describe "from_response/2" do
    test "builds a struct from a well-formed RFC 9457 body" do
      body = %{
        "type" => "invalid_operation_error",
        "title" =>
          "The action you specified can't be performed on the object in its current state.",
        "status" => 409,
        "detail" => "There's an insufficient balance in the account."
      }

      error = Increase.Error.from_response(409, body)

      assert error.type == "invalid_operation_error"
      assert error.status == 409
      assert error.detail == "There's an insufficient balance in the account."
      assert error.raw_body == body
    end

    test "falls back to the HTTP status when the body omits status" do
      body = %{"type" => "not_found", "title" => "Not found", "detail" => nil}
      error = Increase.Error.from_response(404, body)
      assert error.status == 404
    end

    test "handles an unexpected (non-RFC-9457) body shape gracefully" do
      error = Increase.Error.from_response(502, "<html>Bad Gateway</html>")
      assert error.type == "unknown_error"
      assert error.status == 502
      assert error.raw_body == "<html>Bad Gateway</html>"
    end
  end

  describe "from_exception/1" do
    test "normalizes a transport-level failure into the same struct shape" do
      error = Increase.Error.from_exception(%Req.TransportError{reason: :timeout})
      assert error.type == "transport_error"
      assert is_binary(error.detail)
    end
  end

  describe "message/1 (Exception protocol)" do
    test "includes title, detail, and status when all present" do
      error = %Increase.Error{
        type: "invalid_operation_error",
        title: "Bad state",
        detail: "Insufficient balance",
        status: 409
      }

      assert Exception.message(error) == "Bad state: Insufficient balance (status 409)"
    end

    test "omits the detail clause when detail is nil" do
      error = %Increase.Error{title: "Bad state", detail: nil, status: 409}
      assert Exception.message(error) == "Bad state (status 409)"
    end

    test "is raisable like any other exception" do
      error = %Increase.Error{title: "Boom", status: 500}

      assert_raise Increase.Error, "Boom (status 500)", fn ->
        raise error
      end
    end
  end
end
