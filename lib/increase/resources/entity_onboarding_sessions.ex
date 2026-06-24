defmodule Increase.EntityOnboardingSessions do
  @moduledoc """
  Entity Onboarding Sessions let your customers onboard themselves by completing
  Increase-hosted forms. Create a session and redirect your customer to the
  returned URL. When they're done, they'll be redirected back to your site. This
  API is used for [hosted onboarding].

  See https://increase.com/documentation/api/entity-onboarding-sessions for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule EntityOnboardingSession do
    @moduledoc """
    Entity Onboarding Sessions let your customers onboard themselves by
    completing Increase-hosted forms. Create a session and redirect your
    customer to the returned URL. When they're done, they'll be redirected back
    to your site. This API is used for [hosted
    onboarding].

    ## Fields

      * `id` - The Entity Onboarding Session's identifier.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Entity Onboarding Session was created.
      * `entity_id` - The identifier of the Entity associated with this session, if one has been
        created or was provided when creating the session.
      * `expires_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Entity Onboarding Session will expire.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `program_id` - The identifier of the Program the Entity will be onboarded to.
      * `redirect_url` - The URL to redirect to after the onboarding session is complete.
        Increase will include the query parameters
        `entity_onboarding_session_id` and `entity_id` when redirecting.
      * `session_url` - The URL containing the onboarding form. You should share this link with
        your customer. Only present when the session is active.
      * `status` - The status of the onboarding session.
      * `type` - A constant representing the object's type. For this resource it will always be
        `entity_onboarding_session`.
    """

    defstruct [
      :id,
      :created_at,
      :entity_id,
      :expires_at,
      :idempotency_key,
      :program_id,
      :redirect_url,
      :session_url,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            created_at: DateTime.t(),
            entity_id: String.t() | nil,
            expires_at: DateTime.t(),
            idempotency_key: String.t() | nil,
            program_id: String.t(),
            redirect_url: String.t(),
            session_url: String.t() | nil,
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        entity_id: raw["entity_id"],
        expires_at: Increase.Decode.datetime(raw["expires_at"]),
        idempotency_key: raw["idempotency_key"],
        program_id: raw["program_id"],
        redirect_url: raw["redirect_url"],
        session_url: raw["session_url"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an Entity Onboarding Session

  `POST /entity_onboarding_sessions`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, EntityOnboardingSession.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_onboarding_sessions"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, EntityOnboardingSession.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an Entity Onboarding Session

  `GET /entity_onboarding_sessions/{entity_onboarding_session_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, EntityOnboardingSession.t()} | {:error, Increase.Error.t()}
  def retrieve(client, entity_onboarding_session_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_onboarding_sessions/#{entity_onboarding_session_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, EntityOnboardingSession.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Entity Onboarding Session

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  EntityOnboardingSession{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /entity_onboarding_sessions`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_onboarding_sessions"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &EntityOnboardingSession.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Expire an Entity Onboarding Session

  `POST /entity_onboarding_sessions/{entity_onboarding_session_id}/expire`
  """
  @spec expire(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, EntityOnboardingSession.t()} | {:error, Increase.Error.t()}
  def expire(client, entity_onboarding_session_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_onboarding_sessions/#{entity_onboarding_session_id}/expire"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, EntityOnboardingSession.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
