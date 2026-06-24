defmodule Increase.RoutingNumbers do
  @moduledoc """
  Functions for working with RoutingNumbers via the Increase API.

  See https://increase.com/documentation/api/routing-numbers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule RoutingNumberListResponse do
    @moduledoc """
    Routing numbers are used to identify your bank in a financial transaction.

    ## Fields

      * `ach_transfers` - This routing number's support for ACH Transfers.
      * `fednow_transfers` - This routing number's support for FedNow Transfers.
      * `name` - The name of the financial institution belonging to a routing number.
      * `real_time_payments_transfers` - This routing number's support for Real-Time Payments
        Transfers.
      * `routing_number` - The nine digit routing number identifier.
      * `type` - A constant representing the object's type. For this resource it will always be
        `routing_number`.
      * `wire_transfers` - This routing number's support for Wire Transfers.
    """

    defstruct [
      :ach_transfers,
      :fednow_transfers,
      :name,
      :real_time_payments_transfers,
      :routing_number,
      :type,
      :wire_transfers
    ]

    @type t :: %__MODULE__{
            ach_transfers: String.t(),
            fednow_transfers: String.t(),
            name: String.t(),
            real_time_payments_transfers: String.t(),
            routing_number: String.t(),
            type: String.t(),
            wire_transfers: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        ach_transfers: raw["ach_transfers"],
        fednow_transfers: raw["fednow_transfers"],
        name: raw["name"],
        real_time_payments_transfers: raw["real_time_payments_transfers"],
        routing_number: raw["routing_number"],
        type: raw["type"],
        wire_transfers: raw["wire_transfers"]
      }
    end
  end

  @doc """
  You can use this API to confirm if a routing number is valid, such as when a
  user is providing you with bank account details. Since routing numbers
  uniquely identify a bank, this will always return 0 or 1 entry. In Sandbox,
  only a few [routing numbers are
  valid] `110000000` is
  an example of a Sandbox routing number.

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  RoutingNumberListResponse{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /routing_numbers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/routing_numbers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &RoutingNumberListResponse.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
