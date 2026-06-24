defmodule Increase.OAuthConnections do
  @moduledoc """
  When a user authorizes your OAuth application, an OAuth Connection object is
  created. Learn more about OAuth
  [here](https://increase.com/documentation/oauth).

  See https://increase.com/documentation/api/oauth-connections for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule OAuthConnection do
    @moduledoc """
    When a user authorizes your OAuth application, an OAuth Connection object is
    created. Learn more about OAuth
    [here](https://increase.com/documentation/oauth).

    ## Fields

      * `id` - The OAuth Connection's identifier.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) timestamp when the
        OAuth Connection was created.
      * `deleted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) timestamp when the
        OAuth Connection was deleted.
      * `group_id` - The identifier of the Group that has authorized your OAuth application.
      * `oauth_application_id` - The identifier of the OAuth application this connection is for.
      * `status` - Whether the connection is active.
      * `type` - A constant representing the object's type. For this resource it will always be
        `oauth_connection`.
    """

    defstruct [:id, :created_at, :deleted_at, :group_id, :oauth_application_id, :status, :type]

    @type t :: %__MODULE__{
            id: String.t(),
            created_at: DateTime.t(),
            deleted_at: DateTime.t() | nil,
            group_id: String.t(),
            oauth_application_id: String.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        deleted_at: Increase.Decode.datetime(raw["deleted_at"]),
        group_id: raw["group_id"],
        oauth_application_id: raw["oauth_application_id"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve an OAuth Connection

  `GET /oauth_connections/{oauth_connection_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, OAuthConnection.t()} | {:error, Increase.Error.t()}
  def retrieve(client, oauth_connection_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/oauth_connections/#{oauth_connection_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, OAuthConnection.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List OAuth Connections

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  OAuthConnection{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /oauth_connections`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/oauth_connections"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &OAuthConnection.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
