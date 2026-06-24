defmodule Increase.Error do
  @moduledoc """
  Represents an error returned by the Increase API, or a transport-level
  failure (timeout, connection refused, etc).

  API errors conform to [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html)
  and always have the same shape: `type`, `title`, `status`, and a nullable
  `detail`. See the [Errors documentation](https://increase.com/documentation/api/overview#errors)
  for the full list of `type` values.

  ## Examples

      {:error, %Increase.Error{type: "invalid_operation_error", status: 409}} =
        Increase.Accounts.close(client, "account_with_balance")
  """

  defexception type: nil,
               title: nil,
               status: nil,
               detail: nil,
               raw_body: nil

  @type t :: %__MODULE__{
          type: String.t() | nil,
          title: String.t() | nil,
          status: integer() | nil,
          detail: String.t() | nil,
          raw_body: term()
        }

  @impl true
  def message(%__MODULE__{title: title, detail: detail, status: status}) do
    base = title || "Increase API request failed"

    case detail do
      nil -> "#{base} (status #{status})"
      detail -> "#{base}: #{detail} (status #{status})"
    end
  end

  @doc false
  def from_response(status, %{"type" => _} = body) do
    %__MODULE__{
      type: body["type"],
      title: body["title"],
      status: body["status"] || status,
      detail: body["detail"],
      raw_body: body
    }
  end

  def from_response(status, body) do
    %__MODULE__{
      type: "unknown_error",
      title: "Unexpected response shape from Increase API",
      status: status,
      detail: nil,
      raw_body: body
    }
  end

  @doc false
  def from_exception(exception) do
    %__MODULE__{
      type: "transport_error",
      title: "Failed to reach the Increase API",
      status: nil,
      detail: Exception.message(exception),
      raw_body: nil
    }
  end
end
