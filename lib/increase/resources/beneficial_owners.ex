defmodule Increase.BeneficialOwners do
  @moduledoc """
  Functions for working with BeneficialOwners via the Increase API.

  See https://increase.com/documentation/api/beneficial-owners for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule EntityBeneficialOwner do
    @moduledoc """
    Beneficial owners are the individuals who control or own 25% or more of a
    `corporation` entity. Beneficial owners are always people, and never
    organizations. Generally, you will need to submit between 1 and 5 beneficial
    owners for every `corporation` entity. You should update and archive
    beneficial owners for a corporation entity as their details change.

    ## Fields

      * `id` - The identifier of this beneficial owner.
      * `company_title` - This person's role or title within the entity.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Beneficial Owner was created.
      * `entity_id` - The identifier of the Entity to which this beneficial owner belongs.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `individual` - Personal details for the beneficial owner.
      * `prongs` - Why this person is considered a beneficial owner of the entity.
      * `type` - A constant representing the object's type. For this resource it will always be
        `entity_beneficial_owner`.
    """

    defmodule Individual do
      @moduledoc """
      Personal details for the beneficial owner.

      ## Fields

        * `address` - The person's address.
        * `date_of_birth` - The person's date of birth in YYYY-MM-DD format.
        * `identification` - A means of verifying the person's identity.
        * `name` - The person's legal name.
      """

      defmodule Address do
        @moduledoc """
        The person's address.

        ## Fields

          * `city` - The city, district, town, or village of the address.
          * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the address.
          * `line1` - The first line of the address.
          * `line2` - The second line of the address.
          * `state` - The two-letter United States Postal Service (USPS) abbreviation for the US
            state, province, or region of the address.
          * `zip` - The ZIP or postal code of the address.
        """

        defstruct [:city, :country, :line1, :line2, :state, :zip]

        @type t :: %__MODULE__{
                city: String.t() | nil,
                country: String.t(),
                line1: String.t(),
                line2: String.t() | nil,
                state: String.t() | nil,
                zip: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            country: raw["country"],
            line1: raw["line1"],
            line2: raw["line2"],
            state: raw["state"],
            zip: raw["zip"]
          }
        end
      end

      defmodule Identification do
        @moduledoc """
        A means of verifying the person's identity.

        ## Fields

          * `method` - A method that can be used to verify the individual's identity.
          * `number_last4` - The last 4 digits of the identification number that can be used to
            verify the individual's identity.
        """

        defstruct [:method, :number_last4]

        @type t :: %__MODULE__{
                method: String.t(),
                number_last4: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            method: raw["method"],
            number_last4: raw["number_last4"]
          }
        end
      end

      defstruct [:address, :date_of_birth, :identification, :name]

      @type t :: %__MODULE__{
              address: Address.t(),
              date_of_birth: Date.t(),
              identification: Identification.t() | nil,
              name: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          date_of_birth: Increase.Decode.date(raw["date_of_birth"]),
          identification: Increase.Decode.struct(raw["identification"], &Identification.decode/1),
          name: raw["name"]
        }
      end
    end

    defstruct [
      :id,
      :company_title,
      :created_at,
      :entity_id,
      :idempotency_key,
      :individual,
      :prongs,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            company_title: String.t() | nil,
            created_at: DateTime.t(),
            entity_id: String.t(),
            idempotency_key: String.t() | nil,
            individual: Individual.t(),
            prongs: [String.t()],
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        company_title: raw["company_title"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        entity_id: raw["entity_id"],
        idempotency_key: raw["idempotency_key"],
        individual: Increase.Decode.struct(raw["individual"], &Individual.decode/1),
        prongs: raw["prongs"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Beneficial Owner

  `POST /entity_beneficial_owners`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, EntityBeneficialOwner.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_beneficial_owners"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, EntityBeneficialOwner.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Beneficial Owner

  `GET /entity_beneficial_owners/{entity_beneficial_owner_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, EntityBeneficialOwner.t()} | {:error, Increase.Error.t()}
  def retrieve(client, entity_beneficial_owner_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_beneficial_owners/#{entity_beneficial_owner_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, EntityBeneficialOwner.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update a Beneficial Owner

  `PATCH /entity_beneficial_owners/{entity_beneficial_owner_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, EntityBeneficialOwner.t()} | {:error, Increase.Error.t()}
  def update(client, entity_beneficial_owner_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_beneficial_owners/#{entity_beneficial_owner_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, EntityBeneficialOwner.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Beneficial Owners

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  EntityBeneficialOwner{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /entity_beneficial_owners`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_beneficial_owners"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &EntityBeneficialOwner.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Archive a Beneficial Owner

  `POST /entity_beneficial_owners/{entity_beneficial_owner_id}/archive`
  """
  @spec archive(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, EntityBeneficialOwner.t()} | {:error, Increase.Error.t()}
  def archive(client, entity_beneficial_owner_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/entity_beneficial_owners/#{entity_beneficial_owner_id}/archive"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, EntityBeneficialOwner.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
