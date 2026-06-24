defmodule Increase.OAuthApplications do
  @moduledoc """
  An OAuth Application lets you build an application for others to use with their
  Increase data. You can create an OAuth Application via the Dashboard and read
  information about it with the API. Learn more about OAuth
  [here](https://increase.com/documentation/oauth).

  See https://increase.com/documentation/api/oauth-applications for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule OAuthApplication do
    @moduledoc """
    An OAuth Application lets you build an application for others to use with
    their Increase data. You can create an OAuth Application via the Dashboard
    and read information about it with the API. Learn more about OAuth
    [here](https://increase.com/documentation/oauth).

    ## Fields

      * `id` - The OAuth Application's identifier.
      * `client_id` - The OAuth Application's client_id. Use this to authenticate with the OAuth
        Application.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) timestamp when the
        OAuth Application was created.
      * `deleted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) timestamp when the
        OAuth Application was deleted.
      * `name` - The name you chose for this OAuth Application.
      * `status` - Whether the application is active.
      * `type` - A constant representing the object's type. For this resource it will always be
        `oauth_application`.
    """

    defstruct [:id, :client_id, :created_at, :deleted_at, :name, :status, :type]

    @type t :: %__MODULE__{
            id: String.t(),
            client_id: String.t(),
            created_at: DateTime.t(),
            deleted_at: DateTime.t() | nil,
            name: String.t() | nil,
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        client_id: raw["client_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        deleted_at: Increase.Decode.datetime(raw["deleted_at"]),
        name: raw["name"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve an OAuth Application

  `GET /oauth_applications/{oauth_application_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, OAuthApplication.t()} | {:error, Increase.Error.t()}
  def retrieve(client, oauth_application_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/oauth_applications/#{oauth_application_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, OAuthApplication.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List OAuth Applications

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  OAuthApplication{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /oauth_applications`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/oauth_applications"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &OAuthApplication.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
