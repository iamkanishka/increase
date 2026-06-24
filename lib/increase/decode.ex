defmodule Increase.Decode do
  @moduledoc """
  Shared decoding helpers used by every generated `Increase.*` struct's
  `decode/1` function. Not meant to be called directly in application
  code -- see the individual resource struct modules (e.g.
  `Increase.Accounts.Account`) instead.
  """

  @doc """
  Parses an ISO 8601 datetime string into a `DateTime`. Returns `nil`
  unchanged (for nullable fields that are absent), and falls back to the
  raw value unchanged if it doesn't parse as a valid datetime -- since
  the API is the source of truth and a parse failure here shouldn't
  crash decoding of an otherwise-valid response.
  """
  @spec datetime(String.t() | nil) :: DateTime.t() | String.t() | nil
  def datetime(nil), do: nil

  def datetime(value) when is_binary(value) do
    case DateTime.from_iso8601(value) do
      {:ok, dt, _offset} -> dt
      {:error, _reason} -> value
    end
  end

  def datetime(value), do: value

  @doc """
  Parses an ISO 8601 date string (`YYYY-MM-DD`) into a `Date`. Same
  fallback behavior as `datetime/1`.
  """
  @spec date(String.t() | nil) :: Date.t() | String.t() | nil
  def date(nil), do: nil

  def date(value) when is_binary(value) do
    case Date.from_iso8601(value) do
      {:ok, date} -> date
      {:error, _reason} -> value
    end
  end

  def date(value), do: value

  @doc """
  Decodes a single nested object with the given decoder function. Passes
  `nil` through unchanged (for nullable nested objects that are absent).
  """
  @spec struct(map() | nil, (map() -> struct())) :: struct() | nil
  def struct(nil, _decoder), do: nil
  def struct(raw, decoder) when is_map(raw), do: decoder.(raw)

  @doc """
  Decodes a list of nested objects with the given decoder function.
  Passes `nil` through unchanged (some list fields are themselves
  nullable) and decodes each element of a present list.
  """
  @spec list([map()] | nil, (map() -> struct())) :: [struct()] | nil
  def list(nil, _decoder), do: nil
  def list(raw, decoder) when is_list(raw), do: Enum.map(raw, decoder)
end
