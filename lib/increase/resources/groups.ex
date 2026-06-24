defmodule Increase.Groups do
  @moduledoc """
  Groups represent organizations using Increase. You can retrieve information
  about your own organization via the API. More commonly, OAuth platforms can
  retrieve information about the organizations that have granted them access.
  Learn more about OAuth [here](https://increase.com/documentation/oauth).

  See https://increase.com/documentation/api/groups for the full API
  reference for this resource.
  """

  alias Increase.Client

  defmodule Group do
    @moduledoc """
    Groups represent organizations using Increase. You can retrieve information
    about your own organization via the API. More commonly, OAuth platforms can
    retrieve information about the organizations that have granted them access.
    Learn more about OAuth [here](https://increase.com/documentation/oauth).

    ## Fields

      * `id` - The Group identifier.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Group was created.
      * `type` - A constant representing the object's type. For this resource it will always be
        `group`.
    """

    defstruct [:id, :created_at, :type]

    @type t :: %__MODULE__{
            id: String.t(),
            created_at: DateTime.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        type: raw["type"]
      }
    end
  end

  @doc """
  Returns details for the currently authenticated Group.

  `GET /groups/current`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, keyword()) ::
          {:ok, Group.t()} | {:error, Increase.Error.t()}
  def retrieve(client, opts \\ []) do
    client = Client.resolve(client)

    path = "/groups/current"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Group.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
