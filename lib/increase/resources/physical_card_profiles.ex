defmodule Increase.PhysicalCardProfiles do
  @moduledoc """
  This contains artwork and metadata relating to a Physical Card's appearance. For
  more information, see our guide on
  [physical card artwork](https://increase.com/documentation/card-art-physical-cards).

  See https://increase.com/documentation/api/physical-card-profiles for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule PhysicalCardProfile do
    @moduledoc """
    This contains artwork and metadata relating to a Physical Card's appearance.
    For more information, see our guide on [physical card
    artwork](https://increase.com/documentation/card-art-physical-cards).

    ## Fields

      * `id` - The Card Profile identifier.
      * `back_image_file_id` - The identifier of the File containing the physical card's back
        image. This will be missing until the image has been
        post-processed.
      * `carrier_image_file_id` - The identifier of the File containing the physical card's
        carrier image. This will be missing until the image has been
        post-processed.
      * `contact_phone` - A phone number the user can contact to receive support for their card.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Physical Card Profile was created.
      * `creator` - The creator of this Physical Card Profile.
      * `description` - A description you can use to identify the Physical Card Profile.
      * `front_image_file_id` - The identifier of the File containing the physical card's front
        image. This will be missing until the image has been
        post-processed.
      * `front_text` - Text printed on the front of the card. Reach out to
        [support@increase.com](mailto:support@increase.com) for more information.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `is_default` - Whether this Physical Card Profile is the default for all cards in its
        Increase group.
      * `program_id` - The identifier for the Program this Physical Card Profile belongs to.
      * `status` - The status of the Physical Card Profile.
      * `type` - A constant representing the object's type. For this resource it will always be
        `physical_card_profile`.
    """

    defmodule FrontText do
      @moduledoc """
      Text printed on the front of the card. Reach out to
      [support@increase.com](mailto:support@increase.com) for more information.

      ## Fields

        * `line1` - The first line of text on the front of the card.
        * `line2` - The second line of text on the front of the card. Providing a second line
          moves the first line slightly higher and prints the second line in the spot
          where the first line would have otherwise been printed.
      """

      defstruct [:line1, :line2]

      @type t :: %__MODULE__{
              line1: String.t(),
              line2: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          line1: raw["line1"],
          line2: raw["line2"]
        }
      end
    end

    defstruct [
      :id,
      :back_image_file_id,
      :carrier_image_file_id,
      :contact_phone,
      :created_at,
      :creator,
      :description,
      :front_image_file_id,
      :front_text,
      :idempotency_key,
      :is_default,
      :program_id,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            back_image_file_id: String.t() | nil,
            carrier_image_file_id: String.t() | nil,
            contact_phone: String.t() | nil,
            created_at: DateTime.t(),
            creator: String.t(),
            description: String.t(),
            front_image_file_id: String.t() | nil,
            front_text: FrontText.t() | nil,
            idempotency_key: String.t() | nil,
            is_default: boolean(),
            program_id: String.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        back_image_file_id: raw["back_image_file_id"],
        carrier_image_file_id: raw["carrier_image_file_id"],
        contact_phone: raw["contact_phone"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        creator: raw["creator"],
        description: raw["description"],
        front_image_file_id: raw["front_image_file_id"],
        front_text: Increase.Decode.struct(raw["front_text"], &FrontText.decode/1),
        idempotency_key: raw["idempotency_key"],
        is_default: raw["is_default"],
        program_id: raw["program_id"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Physical Card Profile

  `POST /physical_card_profiles`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, PhysicalCardProfile.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_card_profiles"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, PhysicalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Card Profile

  `GET /physical_card_profiles/{physical_card_profile_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, PhysicalCardProfile.t()} | {:error, Increase.Error.t()}
  def retrieve(client, physical_card_profile_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_card_profiles/#{physical_card_profile_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, PhysicalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Physical Card Profiles

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  PhysicalCardProfile{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /physical_card_profiles`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_card_profiles"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &PhysicalCardProfile.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Archive a Physical Card Profile

  `POST /physical_card_profiles/{physical_card_profile_id}/archive`
  """
  @spec archive(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, PhysicalCardProfile.t()} | {:error, Increase.Error.t()}
  def archive(client, physical_card_profile_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_card_profiles/#{physical_card_profile_id}/archive"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, PhysicalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Clone a Physical Card Profile

  `POST /physical_card_profiles/{physical_card_profile_id}/clone`
  """
  @spec clone(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, PhysicalCardProfile.t()} | {:error, Increase.Error.t()}
  def clone(client, physical_card_profile_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_card_profiles/#{physical_card_profile_id}/clone"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, PhysicalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
