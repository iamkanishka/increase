defmodule Increase.EventSubscriptions do
  @moduledoc """
  Webhooks are event notifications we send to you by HTTPS POST requests. Event
  Subscriptions are how you configure your application to listen for them. You can
  create an Event Subscription through your
  [developer dashboard](https://dashboard.increase.com/developers/webhooks) or the
  API. For more information, see our
  [webhooks guide](https://increase.com/documentation/webhooks).

  See https://increase.com/documentation/api/event-subscriptions for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule EventSubscription do
    @moduledoc """
    Webhooks are event notifications we send to you by HTTPS POST requests.
    Event Subscriptions are how you configure your application to listen for
    them. You can create an Event Subscription through your [developer
    dashboard](https://dashboard.increase.com/developers/webhooks) or the API.
    For more information, see our [webhooks
    guide](https://increase.com/documentation/webhooks).

    ## Fields

      * `id` - The event subscription identifier.
      * `created_at` - The time the event subscription was created.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `oauth_connection_id` - If specified, this subscription will only receive webhooks for
        Events associated with this OAuth Connection.
      * `selected_event_categories` - If specified, this subscription will only receive webhooks
        for Events with the specified `category`.
      * `status` - This indicates if we'll send notifications to this subscription.
      * `type` - A constant representing the object's type. For this resource it will always be
        `event_subscription`.
      * `url` - The webhook url where we'll send notifications.
    """

    defmodule SelectedEventCategory do
      @moduledoc """
      The `EventSubscriptionSelectedEventCategory` object.

      ## Fields

        * `event_category` - The category of the Event.
      """

      defstruct [:event_category]

      @type t :: %__MODULE__{
              event_category: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          event_category: raw["event_category"]
        }
      end
    end

    defstruct [
      :id,
      :created_at,
      :idempotency_key,
      :oauth_connection_id,
      :selected_event_categories,
      :status,
      :type,
      :url
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            created_at: DateTime.t(),
            idempotency_key: String.t() | nil,
            oauth_connection_id: String.t() | nil,
            selected_event_categories: [SelectedEventCategory.t()] | nil,
            status: String.t(),
            type: String.t(),
            url: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        idempotency_key: raw["idempotency_key"],
        oauth_connection_id: raw["oauth_connection_id"],
        selected_event_categories:
          Increase.Decode.list(raw["selected_event_categories"], &SelectedEventCategory.decode/1),
        status: raw["status"],
        type: raw["type"],
        url: raw["url"]
      }
    end
  end

  @doc """
  Create an Event Subscription

  `POST /event_subscriptions`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, EventSubscription.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/event_subscriptions"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, EventSubscription.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an Event Subscription

  `GET /event_subscriptions/{event_subscription_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, EventSubscription.t()} | {:error, Increase.Error.t()}
  def retrieve(client, event_subscription_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/event_subscriptions/#{event_subscription_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, EventSubscription.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update an Event Subscription

  `PATCH /event_subscriptions/{event_subscription_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, EventSubscription.t()} | {:error, Increase.Error.t()}
  def update(client, event_subscription_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/event_subscriptions/#{event_subscription_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, EventSubscription.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Event Subscriptions

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  EventSubscription{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /event_subscriptions`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/event_subscriptions"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &EventSubscription.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
