defmodule Increase.CardTokens do
  @moduledoc """
  Card Tokens represent a tokenized card number that can be used for Card Push
  Transfers and Card Validations.

  See https://increase.com/documentation/api/card-tokens for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CardToken do
    @moduledoc """
    Card Tokens represent a tokenized card number that can be used for Card Push
    Transfers and Card Validations.

    ## Fields

      * `id` - The Card Token's identifier.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the card token was created.
      * `expiration_date` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date when the
        card expires.
      * `last4` - The last 4 digits of the card number.
      * `length` - The length of the card number.
      * `prefix` - The prefix of the card number, usually 8 digits.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_token`.
    """

    defstruct [:id, :created_at, :expiration_date, :last4, :length, :prefix, :type]

    @type t :: %__MODULE__{
            id: String.t(),
            created_at: DateTime.t(),
            expiration_date: Date.t(),
            last4: String.t(),
            length: integer(),
            prefix: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        expiration_date: Increase.Decode.date(raw["expiration_date"]),
        last4: raw["last4"],
        length: raw["length"],
        prefix: raw["prefix"],
        type: raw["type"]
      }
    end
  end

  defmodule CardTokenCapabilities do
    @moduledoc """
    The capabilities of a Card Token describe whether the card can be used for
    specific operations, such as Card Push Transfers. The capabilities can
    change over time based on the issuing bank's configuration of the card
    range.

    ## Fields

      * `routes` - Each route represent a path e.g., a push transfer can take.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_token_capabilities`.
    """

    defmodule Route do
      @moduledoc """
      The `CardTokenCapabilitiesRoute` object.

      ## Fields

        * `cross_border_push_transfers` - Whether you can push funds to the card using
          cross-border Card Push Transfers.
        * `domestic_push_transfers` - Whether you can push funds to the card using domestic Card
          Push Transfers.
        * `issuer_country` - The ISO-3166-1 alpha-2 country code of the card's issuing bank.
        * `route` - The card network route the capabilities apply to.
      """

      defstruct [:cross_border_push_transfers, :domestic_push_transfers, :issuer_country, :route]

      @type t :: %__MODULE__{
              cross_border_push_transfers: String.t(),
              domestic_push_transfers: String.t(),
              issuer_country: String.t(),
              route: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          cross_border_push_transfers: raw["cross_border_push_transfers"],
          domestic_push_transfers: raw["domestic_push_transfers"],
          issuer_country: raw["issuer_country"],
          route: raw["route"]
        }
      end
    end

    defstruct [:routes, :type]

    @type t :: %__MODULE__{
            routes: [Route.t()],
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        routes: Increase.Decode.list(raw["routes"], &Route.decode/1),
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve a Card Token

  `GET /card_tokens/{card_token_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardToken.t()} | {:error, Increase.Error.t()}
  def retrieve(client, card_token_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_tokens/#{card_token_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardToken.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Card Tokens

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CardToken{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /card_tokens`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_tokens"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CardToken.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  The capabilities of a Card Token describe whether the card can be used for
  specific operations, such as Card Push Transfers. The capabilities can
  change over time based on the issuing bank's configuration of the card
  range.

  `GET /card_tokens/{card_token_id}/capabilities`
  """
  @spec capabilities(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardTokenCapabilities.t()} | {:error, Increase.Error.t()}
  def capabilities(client, card_token_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_tokens/#{card_token_id}/capabilities"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardTokenCapabilities.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
