defmodule Increase.FileLinks do
  @moduledoc """
  File Links let you generate a URL that can be used to download a File.

  See https://increase.com/documentation/api/file-links for the full API
  reference for this resource.
  """

  alias Increase.Client

  defmodule FileLink do
    @moduledoc """
    File Links let you generate a URL that can be used to download a File.

    ## Fields

      * `id` - The File Link identifier.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        File Link was created.
      * `expires_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        File Link will expire.
      * `file_id` - The identifier of the File the File Link points to.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `type` - A constant representing the object's type. For this resource it will always be
        `file_link`.
      * `unauthenticated_url` - A URL where the File can be downloaded. The URL will expire
        after the `expires_at` time. This URL is unauthenticated and can
        be used to download the File without an Increase API key.
    """

    defstruct [
      :id,
      :created_at,
      :expires_at,
      :file_id,
      :idempotency_key,
      :type,
      :unauthenticated_url
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            created_at: DateTime.t(),
            expires_at: DateTime.t(),
            file_id: String.t(),
            idempotency_key: String.t() | nil,
            type: String.t(),
            unauthenticated_url: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        expires_at: Increase.Decode.datetime(raw["expires_at"]),
        file_id: raw["file_id"],
        idempotency_key: raw["idempotency_key"],
        type: raw["type"],
        unauthenticated_url: raw["unauthenticated_url"]
      }
    end
  end

  @doc """
  Create a File Link

  `POST /file_links`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, FileLink.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/file_links"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, FileLink.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
