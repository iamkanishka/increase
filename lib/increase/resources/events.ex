defmodule Increase.Events do
  @moduledoc """
  Events are records of things that happened to objects at Increase. Events are
  accessible via the List Events endpoint and can be delivered to your application
  via webhooks. For more information, see our
  [webhooks guide](https://increase.com/documentation/webhooks).

  See https://increase.com/documentation/api/events for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule Event do
    @moduledoc """
    Events are records of things that happened to objects at Increase. Events
    are accessible via the List Events endpoint and can be delivered to your
    application via webhooks. For more information, see our [webhooks
    guide](https://increase.com/documentation/webhooks).

    ## Fields

      * `id` - The Event identifier.
      * `associated_object_id` - The identifier of the object that generated this Event.
      * `associated_object_type` - The type of the object that generated this Event.
      * `category` - The category of the Event. We may add additional possible values for this
        enum over time; your application should be able to handle such additions
        gracefully.
      * `created_at` - The time the Event was created.
      * `type` - A constant representing the object's type. For this resource it will always be
        `event`.
    """

    defstruct [:id, :associated_object_id, :associated_object_type, :category, :created_at, :type]

    @type t :: %__MODULE__{
            id: String.t(),
            associated_object_id: String.t(),
            associated_object_type: String.t(),
            category: String.t(),
            created_at: DateTime.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        associated_object_id: raw["associated_object_id"],
        associated_object_type: raw["associated_object_type"],
        category: raw["category"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve an Event

  `GET /events/{event_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Event.t()} | {:error, Increase.Error.t()}
  def retrieve(client, event_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/events/#{event_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Event.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Events

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  Event{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /events`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/events"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &Event.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
