defmodule Increase.SupplementalDocuments do
  @moduledoc """
  Functions for working with SupplementalDocuments via the Increase API.

  See https://increase.com/documentation/api/supplemental-documents for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule EntitySupplementalDocument do
    @moduledoc """
    Supplemental Documents are uploaded files connected to an Entity during
    onboarding.

    ## Fields

      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Supplemental Document was created.
      * `entity_id` - The Entity the supplemental document is attached to.
      * `file_id` - The File containing the document.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `type` - A constant representing the object's type. For this resource it will always be
        `entity_supplemental_document`.
    """

    defstruct [:created_at, :entity_id, :file_id, :idempotency_key, :type]

    @type t :: %__MODULE__{
            created_at: DateTime.t(),
            entity_id: String.t(),
            file_id: String.t(),
            idempotency_key: String.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        created_at: Increase.Decode.datetime(raw["created_at"]),
        entity_id: raw["entity_id"],
        file_id: raw["file_id"],
        idempotency_key: raw["idempotency_key"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a supplemental document for an Entity

  `POST /entity_supplemental_documents`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, EntitySupplementalDocument.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_supplemental_documents"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, EntitySupplementalDocument.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Entity Supplemental Document Submissions

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  EntitySupplementalDocument{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /entity_supplemental_documents`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_supplemental_documents"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &EntitySupplementalDocument.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
