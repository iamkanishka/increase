defmodule Increase.DecodeTest do
  use ExUnit.Case, async: true

  alias Increase.Decode

  describe "datetime/1" do
    test "parses a valid ISO 8601 datetime string" do
      assert Decode.datetime("2024-01-01T12:00:00Z") == ~U[2024-01-01 12:00:00Z]
    end

    test "passes nil through unchanged" do
      assert Decode.datetime(nil) == nil
    end

    test "falls back to the raw value if parsing fails, rather than raising" do
      assert Decode.datetime("not-a-date") == "not-a-date"
    end
  end

  describe "date/1" do
    test "parses a valid ISO 8601 date string" do
      assert Decode.date("2024-01-01") == ~D[2024-01-01]
    end

    test "passes nil through unchanged" do
      assert Decode.date(nil) == nil
    end

    test "falls back to the raw value if parsing fails, rather than raising" do
      assert Decode.date("not-a-date") == "not-a-date"
    end
  end

  describe "struct/2" do
    test "decodes a present map with the given decoder" do
      decoder = fn raw -> %{decoded: true, original: raw} end
      assert Decode.struct(%{"a" => 1}, decoder) == %{decoded: true, original: %{"a" => 1}}
    end

    test "passes nil through unchanged without calling the decoder" do
      decoder = fn _ -> raise "should not be called" end
      assert Decode.struct(nil, decoder) == nil
    end
  end

  describe "list/2" do
    test "decodes every element of a present list" do
      decoder = fn raw -> Map.put(raw, :decoded, true) end
      result = Decode.list([%{"a" => 1}, %{"a" => 2}], decoder)
      assert result == [%{"a" => 1, decoded: true}, %{"a" => 2, decoded: true}]
    end

    test "passes nil through unchanged without calling the decoder" do
      decoder = fn _ -> raise "should not be called" end
      assert Decode.list(nil, decoder) == nil
    end

    test "returns an empty list for an empty input list" do
      decoder = fn _ -> raise "should not be called" end
      assert Decode.list([], decoder) == []
    end
  end
end
