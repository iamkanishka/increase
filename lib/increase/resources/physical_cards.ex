defmodule Increase.PhysicalCards do
  @moduledoc """
  Custom physical Visa cards that are shipped to your customers. The artwork is
  configurable by a connected [Card Profile].
  The same Card can be used for multiple Physical Cards. Printing cards incurs a
  fee. Please contact [support@increase.com](mailto:support@increase.com) for
  pricing!

  See https://increase.com/documentation/api/physical-cards for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule PhysicalCard do
    @moduledoc """
    Custom physical Visa cards that are shipped to your customers. The artwork
    is configurable by a connected [Card
    Profile]. The same Card can be used for
    multiple Physical Cards. Printing cards incurs a fee. Please contact
    [support@increase.com](mailto:support@increase.com) for pricing!

    ## Fields

      * `id` - The physical card identifier.
      * `card_id` - The identifier for the Card this Physical Card represents.
      * `cardholder` - Details about the cardholder, as it appears on the printed card.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Physical Card was created.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `physical_card_profile_id` - The Physical Card Profile used for this Physical Card.
      * `shipment` - The details used to ship this physical card.
      * `status` - The status of the Physical Card.
      * `type` - A constant representing the object's type. For this resource it will always be
        `physical_card`.
    """

    defmodule Cardholder do
      @moduledoc """
      Details about the cardholder, as it appears on the printed card.

      ## Fields

        * `first_name` - The cardholder's first name.
        * `last_name` - The cardholder's last name.
      """

      defstruct [:first_name, :last_name]

      @type t :: %__MODULE__{
              first_name: String.t(),
              last_name: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          first_name: raw["first_name"],
          last_name: raw["last_name"]
        }
      end
    end

    defmodule Shipment do
      @moduledoc """
      The details used to ship this physical card.

      ## Fields

        * `address` - The location to where the card's packing label is addressed.
        * `method` - The shipping method.
        * `schedule` - When this physical card should be produced by the card printer. The
          default timeline is the day after the card printer receives the order,
          except for `FEDEX_PRIORITY_OVERNIGHT` cards, which default to `SAME_DAY`.
          To use faster production methods, please reach out to
          [support@increase.com](mailto:support@increase.com).
        * `status` - The status of this shipment.
        * `tracking` - Tracking details for the shipment.
      """

      defmodule Address do
        @moduledoc """
        The location to where the card's packing label is addressed.

        ## Fields

          * `city` - The city of the shipping address.
          * `country` - The country of the shipping address.
          * `line1` - The first line of the shipping address.
          * `line2` - The second line of the shipping address.
          * `line3` - The third line of the shipping address.
          * `name` - The name of the recipient.
          * `postal_code` - The postal code of the shipping address.
          * `state` - The state of the shipping address.
        """

        defstruct [:city, :country, :line1, :line2, :line3, :name, :postal_code, :state]

        @type t :: %__MODULE__{
                city: String.t(),
                country: String.t(),
                line1: String.t(),
                line2: String.t() | nil,
                line3: String.t() | nil,
                name: String.t(),
                postal_code: String.t(),
                state: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            country: raw["country"],
            line1: raw["line1"],
            line2: raw["line2"],
            line3: raw["line3"],
            name: raw["name"],
            postal_code: raw["postal_code"],
            state: raw["state"]
          }
        end
      end

      defmodule Tracking do
        @moduledoc """
        Tracking details for the shipment.

        ## Fields

          * `number` - The tracking number. Not available for USPS shipments.
          * `return_number` - For returned shipments, the tracking number of the return
            shipment.
          * `return_reason` - For returned shipments, this describes why the package was
            returned.
          * `shipped_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
            at which the fulfillment provider marked the card as ready for
            pick-up by the shipment carrier.
          * `updates` - Tracking updates relating to the physical card's delivery.
        """

        defmodule Update do
          @moduledoc """
          The `PhysicalCardShipmentTrackingUpdate` object.

          ## Fields

            * `carrier_estimated_delivery_at` - The [ISO
              8601](https://en.wikipedia.org/wiki/ISO_8601)
              date and time when the carrier expects the card
              to be delivered.
            * `category` - The type of tracking event.
            * `city` - The city where the event took place.
            * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and
              time at which the tracking event took place.
            * `postal_code` - The postal code where the event took place.
            * `state` - The state where the event took place.
          """

          defstruct [
            :carrier_estimated_delivery_at,
            :category,
            :city,
            :created_at,
            :postal_code,
            :state
          ]

          @type t :: %__MODULE__{
                  carrier_estimated_delivery_at: DateTime.t() | nil,
                  category: String.t(),
                  city: String.t() | nil,
                  created_at: DateTime.t(),
                  postal_code: String.t() | nil,
                  state: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              carrier_estimated_delivery_at:
                Increase.Decode.datetime(raw["carrier_estimated_delivery_at"]),
              category: raw["category"],
              city: raw["city"],
              created_at: Increase.Decode.datetime(raw["created_at"]),
              postal_code: raw["postal_code"],
              state: raw["state"]
            }
          end
        end

        defstruct [:number, :return_number, :return_reason, :shipped_at, :updates]

        @type t :: %__MODULE__{
                number: String.t() | nil,
                return_number: String.t() | nil,
                return_reason: String.t() | nil,
                shipped_at: DateTime.t(),
                updates: [Update.t()]
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            number: raw["number"],
            return_number: raw["return_number"],
            return_reason: raw["return_reason"],
            shipped_at: Increase.Decode.datetime(raw["shipped_at"]),
            updates: Increase.Decode.list(raw["updates"], &Update.decode/1)
          }
        end
      end

      defstruct [:address, :method, :schedule, :status, :tracking]

      @type t :: %__MODULE__{
              address: Address.t(),
              method: String.t(),
              schedule: String.t(),
              status: String.t(),
              tracking: Tracking.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          method: raw["method"],
          schedule: raw["schedule"],
          status: raw["status"],
          tracking: Increase.Decode.struct(raw["tracking"], &Tracking.decode/1)
        }
      end
    end

    defstruct [
      :id,
      :card_id,
      :cardholder,
      :created_at,
      :idempotency_key,
      :physical_card_profile_id,
      :shipment,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            card_id: String.t(),
            cardholder: Cardholder.t(),
            created_at: DateTime.t(),
            idempotency_key: String.t() | nil,
            physical_card_profile_id: String.t() | nil,
            shipment: Shipment.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        card_id: raw["card_id"],
        cardholder: Increase.Decode.struct(raw["cardholder"], &Cardholder.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        idempotency_key: raw["idempotency_key"],
        physical_card_profile_id: raw["physical_card_profile_id"],
        shipment: Increase.Decode.struct(raw["shipment"], &Shipment.decode/1),
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Physical Card

  `POST /physical_cards`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, PhysicalCard.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_cards"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, PhysicalCard.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Physical Card

  `GET /physical_cards/{physical_card_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, PhysicalCard.t()} | {:error, Increase.Error.t()}
  def retrieve(client, physical_card_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_cards/#{physical_card_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, PhysicalCard.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update a Physical Card

  `PATCH /physical_cards/{physical_card_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, PhysicalCard.t()} | {:error, Increase.Error.t()}
  def update(client, physical_card_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_cards/#{physical_card_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, PhysicalCard.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Physical Cards

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  PhysicalCard{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /physical_cards`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/physical_cards"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &PhysicalCard.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
