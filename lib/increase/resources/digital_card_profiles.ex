defmodule Increase.DigitalCardProfiles do
  @moduledoc """
  This contains artwork and metadata relating to a Card's appearance in digital
  wallet apps like Apple Pay and Google Pay. For more information, see our guide
  on [digital card artwork](https://increase.com/documentation/card-art).

  See https://increase.com/documentation/api/digital-card-profiles for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule DigitalCardProfile do
    @moduledoc """
    This contains artwork and metadata relating to a Card's appearance in
    digital wallet apps like Apple Pay and Google Pay. For more information, see
    our guide on [digital card
    artwork](https://increase.com/documentation/card-art).

    ## Fields

      * `id` - The Card Profile identifier.
      * `app_icon_file_id` - The identifier of the File containing the card's icon image.
      * `background_image_file_id` - The identifier of the File containing the card's front
        image.
      * `card_description` - A user-facing description for the card itself.
      * `contact_email` - An email address the user can contact to receive support for their
        card.
      * `contact_phone` - A phone number the user can contact to receive support for their card.
      * `contact_website` - A website the user can visit to view and receive support for their
        card.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Digital Card Profile was created.
      * `description` - A description you can use to identify the Card Profile.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `issuer_name` - A user-facing description for whoever is issuing the card.
      * `status` - The status of the Card Profile.
      * `text_color` - The Card's text color, specified as an RGB triple.
      * `type` - A constant representing the object's type. For this resource it will always be
        `digital_card_profile`.
    """

    defmodule TextColor do
      @moduledoc """
      The Card's text color, specified as an RGB triple.

      ## Fields

        * `blue` - The value of the blue channel in the RGB color.
        * `green` - The value of the green channel in the RGB color.
        * `red` - The value of the red channel in the RGB color.
      """

      defstruct [:blue, :green, :red]

      @type t :: %__MODULE__{
              blue: integer(),
              green: integer(),
              red: integer()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          blue: raw["blue"],
          green: raw["green"],
          red: raw["red"]
        }
      end
    end

    defstruct [
      :id,
      :app_icon_file_id,
      :background_image_file_id,
      :card_description,
      :contact_email,
      :contact_phone,
      :contact_website,
      :created_at,
      :description,
      :idempotency_key,
      :issuer_name,
      :status,
      :text_color,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            app_icon_file_id: String.t(),
            background_image_file_id: String.t(),
            card_description: String.t(),
            contact_email: String.t() | nil,
            contact_phone: String.t() | nil,
            contact_website: String.t() | nil,
            created_at: DateTime.t(),
            description: String.t(),
            idempotency_key: String.t() | nil,
            issuer_name: String.t(),
            status: String.t(),
            text_color: TextColor.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        app_icon_file_id: raw["app_icon_file_id"],
        background_image_file_id: raw["background_image_file_id"],
        card_description: raw["card_description"],
        contact_email: raw["contact_email"],
        contact_phone: raw["contact_phone"],
        contact_website: raw["contact_website"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        description: raw["description"],
        idempotency_key: raw["idempotency_key"],
        issuer_name: raw["issuer_name"],
        status: raw["status"],
        text_color: Increase.Decode.struct(raw["text_color"], &TextColor.decode/1),
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Digital Card Profile

  `POST /digital_card_profiles`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, DigitalCardProfile.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/digital_card_profiles"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, DigitalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Digital Card Profile

  `GET /digital_card_profiles/{digital_card_profile_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, DigitalCardProfile.t()} | {:error, Increase.Error.t()}
  def retrieve(client, digital_card_profile_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/digital_card_profiles/#{digital_card_profile_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, DigitalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Card Profiles

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  DigitalCardProfile{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /digital_card_profiles`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/digital_card_profiles"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &DigitalCardProfile.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Archive a Digital Card Profile

  `POST /digital_card_profiles/{digital_card_profile_id}/archive`
  """
  @spec archive(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, DigitalCardProfile.t()} | {:error, Increase.Error.t()}
  def archive(client, digital_card_profile_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/digital_card_profiles/#{digital_card_profile_id}/archive"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, DigitalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Clones a Digital Card Profile

  `POST /digital_card_profiles/{digital_card_profile_id}/clone`
  """
  @spec clone(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, DigitalCardProfile.t()} | {:error, Increase.Error.t()}
  def clone(client, digital_card_profile_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/digital_card_profiles/#{digital_card_profile_id}/clone"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, DigitalCardProfile.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
