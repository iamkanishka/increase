defmodule Increase.DigitalWalletTokens do
  @moduledoc """
  A Digital Wallet Token is created when a user adds a Card to their Apple Pay or
  Google Pay app. The Digital Wallet Token can be used for purchases just like a
  Card.

  See https://increase.com/documentation/api/digital-wallet-tokens for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule DigitalWalletToken do
    @moduledoc """
    A Digital Wallet Token is created when a user adds a Card to their Apple Pay
    or Google Pay app. The Digital Wallet Token can be used for purchases just
    like a Card.

    ## Fields

      * `id` - The Digital Wallet Token identifier.
      * `card_id` - The identifier for the Card this Digital Wallet Token belongs to.
      * `cardholder` - The cardholder information given when the Digital Wallet Token was
        created.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Digital Wallet Token was created.
      * `decline` - If the Digital Wallet Token was declined during provisioning, details about
        the decline.
      * `device` - The device that was used to create the Digital Wallet Token.
      * `dynamic_primary_account_number` - The redacted Dynamic Primary Account Number.
      * `status` - This indicates if payments can be made with the Digital Wallet Token.
      * `token_requestor` - The digital wallet app being used.
      * `type` - A constant representing the object's type. For this resource it will always be
        `digital_wallet_token`.
      * `updates` - Updates to the Digital Wallet Token.
    """

    defmodule Cardholder do
      @moduledoc """
      The cardholder information given when the Digital Wallet Token was created.

      ## Fields

        * `name` - Name of the cardholder, for example "John Smith".
      """

      defstruct [:name]

      @type t :: %__MODULE__{
              name: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          name: raw["name"]
        }
      end
    end

    defmodule Decline do
      @moduledoc """
      If the Digital Wallet Token was declined during provisioning, details about
      the decline.

      ## Fields

        * `reason` - The reason the token provisioning was declined.
      """

      defstruct [:reason]

      @type t :: %__MODULE__{
              reason: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reason: raw["reason"]
        }
      end
    end

    defmodule Device do
      @moduledoc """
      The device that was used to create the Digital Wallet Token.

      ## Fields

        * `device_type` - Device type.
        * `identifier` - ID assigned to the device by the digital wallet provider.
        * `ip_address` - IP address of the device.
        * `name` - Name of the device, for example "My Work Phone".
      """

      defstruct [:device_type, :identifier, :ip_address, :name]

      @type t :: %__MODULE__{
              device_type: String.t() | nil,
              identifier: String.t() | nil,
              ip_address: String.t() | nil,
              name: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          device_type: raw["device_type"],
          identifier: raw["identifier"],
          ip_address: raw["ip_address"],
          name: raw["name"]
        }
      end
    end

    defmodule DynamicPrimaryAccountNumber do
      @moduledoc """
      The redacted Dynamic Primary Account Number.

      ## Fields

        * `first6` - The first 6 digits of the token's Dynamic Primary Account Number.
        * `last4` - The last 4 digits of the token's Dynamic Primary Account Number.
      """

      defstruct [:first6, :last4]

      @type t :: %__MODULE__{
              first6: String.t(),
              last4: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          first6: raw["first6"],
          last4: raw["last4"]
        }
      end
    end

    defmodule Update do
      @moduledoc """
      The `DigitalWalletTokenUpdate` object.

      ## Fields

        * `status` - The status the update changed this Digital Wallet Token to.
        * `timestamp` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the update happened.
      """

      defstruct [:status, :timestamp]

      @type t :: %__MODULE__{
              status: String.t(),
              timestamp: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          status: raw["status"],
          timestamp: Increase.Decode.datetime(raw["timestamp"])
        }
      end
    end

    defstruct [
      :id,
      :card_id,
      :cardholder,
      :created_at,
      :decline,
      :device,
      :dynamic_primary_account_number,
      :status,
      :token_requestor,
      :type,
      :updates
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            card_id: String.t(),
            cardholder: Cardholder.t(),
            created_at: DateTime.t(),
            decline: Decline.t() | nil,
            device: Device.t(),
            dynamic_primary_account_number: DynamicPrimaryAccountNumber.t() | nil,
            status: String.t(),
            token_requestor: String.t(),
            type: String.t(),
            updates: [Update.t()]
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        card_id: raw["card_id"],
        cardholder: Increase.Decode.struct(raw["cardholder"], &Cardholder.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        decline: Increase.Decode.struct(raw["decline"], &Decline.decode/1),
        device: Increase.Decode.struct(raw["device"], &Device.decode/1),
        dynamic_primary_account_number:
          Increase.Decode.struct(
            raw["dynamic_primary_account_number"],
            &DynamicPrimaryAccountNumber.decode/1
          ),
        status: raw["status"],
        token_requestor: raw["token_requestor"],
        type: raw["type"],
        updates: Increase.Decode.list(raw["updates"], &Update.decode/1)
      }
    end
  end

  @doc """
  Retrieve a Digital Wallet Token

  `GET /digital_wallet_tokens/{digital_wallet_token_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, DigitalWalletToken.t()} | {:error, Increase.Error.t()}
  def retrieve(client, digital_wallet_token_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/digital_wallet_tokens/#{digital_wallet_token_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, DigitalWalletToken.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Digital Wallet Tokens

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  DigitalWalletToken{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /digital_wallet_tokens`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/digital_wallet_tokens"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &DigitalWalletToken.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
