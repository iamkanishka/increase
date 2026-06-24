defmodule Increase.OAuthTokens do
  @moduledoc """
  A token that is returned to your application when a user completes the OAuth
  flow and may be used to authenticate requests. Learn more about OAuth
  [here].

  See https://increase.com/documentation/api/oauth-tokens for the full API
  reference for this resource.
  """

  alias Increase.Client

  defmodule OAuthToken do
    @moduledoc """
    A token that is returned to your application when a user completes the OAuth
    flow and may be used to authenticate requests. Learn more about OAuth
    [here].

    ## Fields

      * `access_token` - You may use this token in place of an API key to make OAuth requests on
        a user's behalf.
      * `group_id` - The Group's identifier. A Group is the top-level organization in Increase.
      * `token_type` - The type of OAuth token.
      * `type` - A constant representing the object's type. For this resource it will always be
        `oauth_token`.
    """

    defstruct [:access_token, :group_id, :token_type, :type]

    @type t :: %__MODULE__{
            access_token: String.t(),
            group_id: String.t(),
            token_type: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        access_token: raw["access_token"],
        group_id: raw["group_id"],
        token_type: raw["token_type"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an OAuth Token

  `POST /oauth/tokens`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, OAuthToken.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/oauth/tokens"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, OAuthToken.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
