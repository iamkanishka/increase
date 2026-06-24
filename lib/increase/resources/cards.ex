defmodule Increase.Cards do
  @moduledoc """
  Cards may operate on credit, debit, or prepaid BINs. They’ll immediately work
  for online purchases after you create them. All cards work on a good funds
  model, and maintain a maximum limit of 100% of the Account’s available balance
  at the time of transaction. Funds are deducted from the Account upon transaction
  settlement.

  See https://increase.com/documentation/api/cards for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule Card do
    @moduledoc """
    Cards may operate on credit, debit, or prepaid BINs. They’ll immediately
    work for online purchases after you create them. All cards work on a good
    funds model, and maintain a maximum limit of 100% of the Account’s available
    balance at the time of transaction. Funds are deducted from the Account upon
    transaction settlement.

    ## Fields

      * `id` - The card identifier.
      * `account_id` - The identifier for the account this card belongs to.
      * `authorization_controls` - Controls that restrict how this card can be used.
      * `billing_address` - The Card's billing address.
      * `bin` - The Bank Identification Number (BIN) of the Card.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Card was created.
      * `description` - The card's description for display purposes.
      * `digital_wallet` - The contact information used in the two-factor steps for digital
        wallet card creation. At least one field must be present to complete
        the digital wallet steps.
      * `entity_id` - The identifier for the entity associated with this card.
      * `expiration_month` - The month the card expires in M format (e.g., August is 8).
      * `expiration_year` - The year the card expires in YYYY format (e.g., 2025).
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `last4` - The last 4 digits of the Card's Primary Account Number.
      * `status` - This indicates if payments can be made with the card.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card`.
    """

    defmodule AuthorizationControls do
      @moduledoc """
      Controls that restrict how this card can be used.

      ## Fields

        * `merchant_acceptor_identifier` - Restricts which Merchant Acceptor IDs are allowed or
          blocked for authorizations on this card.
        * `merchant_category_code` - Restricts which Merchant Category Codes are allowed or
          blocked for authorizations on this card.
        * `merchant_country` - Restricts which merchant countries are allowed or blocked for
          authorizations on this card.
        * `usage` - Controls how many times this card can be used.
      """

      defmodule MerchantAcceptorIdentifier do
        @moduledoc """
        Restricts which Merchant Acceptor IDs are allowed or blocked for
        authorizations on this card.

        ## Fields

          * `allowed` - The Merchant Acceptor IDs that are allowed for authorizations on this
            card.
          * `blocked` - The Merchant Acceptor IDs that are blocked for authorizations on this
            card.
        """

        defmodule Allowed do
          @moduledoc """
          The `CardAuthorizationControlsMerchantAcceptorIdentifierAllowed` object.

          ## Fields

            * `identifier` - The Merchant Acceptor ID.
          """

          defstruct [:identifier]

          @type t :: %__MODULE__{
                  identifier: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              identifier: raw["identifier"]
            }
          end
        end

        defmodule Blocked do
          @moduledoc """
          The `CardAuthorizationControlsMerchantAcceptorIdentifierBlocked` object.

          ## Fields

            * `identifier` - The Merchant Acceptor ID.
          """

          defstruct [:identifier]

          @type t :: %__MODULE__{
                  identifier: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              identifier: raw["identifier"]
            }
          end
        end

        defstruct [:allowed, :blocked]

        @type t :: %__MODULE__{
                allowed: [Allowed.t()] | nil,
                blocked: [Blocked.t()] | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            allowed: Increase.Decode.list(raw["allowed"], &Allowed.decode/1),
            blocked: Increase.Decode.list(raw["blocked"], &Blocked.decode/1)
          }
        end
      end

      defmodule MerchantCategoryCode do
        @moduledoc """
        Restricts which Merchant Category Codes are allowed or blocked for
        authorizations on this card.

        ## Fields

          * `allowed` - The Merchant Category Codes that are allowed for authorizations on this
            card.
          * `blocked` - The Merchant Category Codes that are blocked for authorizations on this
            card.
        """

        defmodule Allowed do
          @moduledoc """
          The `CardAuthorizationControlsMerchantCategoryCodeAllowed` object.

          ## Fields

            * `code` - The Merchant Category Code (MCC).
          """

          defstruct [:code]

          @type t :: %__MODULE__{
                  code: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              code: raw["code"]
            }
          end
        end

        defmodule Blocked do
          @moduledoc """
          The `CardAuthorizationControlsMerchantCategoryCodeBlocked` object.

          ## Fields

            * `code` - The Merchant Category Code (MCC).
          """

          defstruct [:code]

          @type t :: %__MODULE__{
                  code: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              code: raw["code"]
            }
          end
        end

        defstruct [:allowed, :blocked]

        @type t :: %__MODULE__{
                allowed: [Allowed.t()] | nil,
                blocked: [Blocked.t()] | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            allowed: Increase.Decode.list(raw["allowed"], &Allowed.decode/1),
            blocked: Increase.Decode.list(raw["blocked"], &Blocked.decode/1)
          }
        end
      end

      defmodule MerchantCountry do
        @moduledoc """
        Restricts which merchant countries are allowed or blocked for authorizations
        on this card.

        ## Fields

          * `allowed` - The merchant countries that are allowed for authorizations on this card.
          * `blocked` - The merchant countries that are blocked for authorizations on this card.
        """

        defmodule Allowed do
          @moduledoc """
          The `CardAuthorizationControlsMerchantCountryAllowed` object.

          ## Fields

            * `country` - The ISO 3166-1 alpha-2 country code.
          """

          defstruct [:country]

          @type t :: %__MODULE__{
                  country: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              country: raw["country"]
            }
          end
        end

        defmodule Blocked do
          @moduledoc """
          The `CardAuthorizationControlsMerchantCountryBlocked` object.

          ## Fields

            * `country` - The ISO 3166-1 alpha-2 country code.
          """

          defstruct [:country]

          @type t :: %__MODULE__{
                  country: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              country: raw["country"]
            }
          end
        end

        defstruct [:allowed, :blocked]

        @type t :: %__MODULE__{
                allowed: [Allowed.t()] | nil,
                blocked: [Blocked.t()] | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            allowed: Increase.Decode.list(raw["allowed"], &Allowed.decode/1),
            blocked: Increase.Decode.list(raw["blocked"], &Blocked.decode/1)
          }
        end
      end

      defmodule Usage do
        @moduledoc """
        Controls how many times this card can be used.

        ## Fields

          * `category` - Whether the card is for a single use or multiple uses.
          * `multi_use` - Controls for multi-use cards. Required if and only if `category` is
            `multi_use`.
          * `single_use` - Controls for single-use cards. Required if and only if `category` is
            `single_use`.
        """

        defmodule MultiUse do
          @moduledoc """
          Controls for multi-use cards. Required if and only if `category` is
          `multi_use`.

          ## Fields

            * `spending_limits` - Spending limits for this card. The most restrictive limit
              applies if multiple limits match.
          """

          defmodule SpendingLimit do
            @moduledoc """
            The `CardAuthorizationControlsUsageMultiUseSpendingLimit` object.

            ## Fields

              * `interval` - The interval at which the spending limit is enforced.
              * `merchant_category_codes` - The Merchant Category Codes (MCCs) this spending
                limit applies to. If not set, the limit applies to
                all transactions.
              * `settlement_amount` - The maximum settlement amount permitted in the given
                interval.
            """

            defmodule CardAuthorizationControlsUsageMultiUseSpendingLimitsMerchantCategoryCode do
              @moduledoc """
              The `CardAuthorizationControlsUsageMultiUseSpendingLimitsMerchantCategoryCode` object.

              ## Fields

                * `code` - The Merchant Category Code (MCC).
              """

              defstruct [:code]

              @type t :: %__MODULE__{
                      code: String.t()
                    }

              @doc false
              @spec decode(map()) :: t()
              def decode(raw) when is_map(raw) do
                %__MODULE__{
                  code: raw["code"]
                }
              end
            end

            defstruct [:interval, :merchant_category_codes, :settlement_amount]

            @type t :: %__MODULE__{
                    interval: String.t(),
                    merchant_category_codes:
                      [
                        CardAuthorizationControlsUsageMultiUseSpendingLimitsMerchantCategoryCode.t()
                      ]
                      | nil,
                    settlement_amount: integer()
                  }

            @doc false
            @spec decode(map()) :: t()
            def decode(raw) when is_map(raw) do
              %__MODULE__{
                interval: raw["interval"],
                merchant_category_codes:
                  Increase.Decode.list(
                    raw["merchant_category_codes"],
                    &CardAuthorizationControlsUsageMultiUseSpendingLimitsMerchantCategoryCode.decode/1
                  ),
                settlement_amount: raw["settlement_amount"]
              }
            end
          end

          defstruct [:spending_limits]

          @type t :: %__MODULE__{
                  spending_limits: [SpendingLimit.t()] | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              spending_limits:
                Increase.Decode.list(raw["spending_limits"], &SpendingLimit.decode/1)
            }
          end
        end

        defmodule SingleUse do
          @moduledoc """
          Controls for single-use cards. Required if and only if `category` is
          `single_use`.

          ## Fields

            * `settlement_amount` - The settlement amount constraint for this single-use card.
          """

          defmodule SettlementAmount do
            @moduledoc """
            The settlement amount constraint for this single-use card.

            ## Fields

              * `comparison` - The operator used to compare the settlement amount.
              * `value` - The settlement amount value.
            """

            defstruct [:comparison, :value]

            @type t :: %__MODULE__{
                    comparison: String.t(),
                    value: integer()
                  }

            @doc false
            @spec decode(map()) :: t()
            def decode(raw) when is_map(raw) do
              %__MODULE__{
                comparison: raw["comparison"],
                value: raw["value"]
              }
            end
          end

          defstruct [:settlement_amount]

          @type t :: %__MODULE__{
                  settlement_amount: SettlementAmount.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              settlement_amount:
                Increase.Decode.struct(raw["settlement_amount"], &SettlementAmount.decode/1)
            }
          end
        end

        defstruct [:category, :multi_use, :single_use]

        @type t :: %__MODULE__{
                category: String.t(),
                multi_use: MultiUse.t() | nil,
                single_use: SingleUse.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            category: raw["category"],
            multi_use: Increase.Decode.struct(raw["multi_use"], &MultiUse.decode/1),
            single_use: Increase.Decode.struct(raw["single_use"], &SingleUse.decode/1)
          }
        end
      end

      defstruct [
        :merchant_acceptor_identifier,
        :merchant_category_code,
        :merchant_country,
        :usage
      ]

      @type t :: %__MODULE__{
              merchant_acceptor_identifier: MerchantAcceptorIdentifier.t() | nil,
              merchant_category_code: MerchantCategoryCode.t() | nil,
              merchant_country: MerchantCountry.t() | nil,
              usage: Usage.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          merchant_acceptor_identifier:
            Increase.Decode.struct(
              raw["merchant_acceptor_identifier"],
              &MerchantAcceptorIdentifier.decode/1
            ),
          merchant_category_code:
            Increase.Decode.struct(raw["merchant_category_code"], &MerchantCategoryCode.decode/1),
          merchant_country:
            Increase.Decode.struct(raw["merchant_country"], &MerchantCountry.decode/1),
          usage: Increase.Decode.struct(raw["usage"], &Usage.decode/1)
        }
      end
    end

    defmodule BillingAddress do
      @moduledoc """
      The Card's billing address.

      ## Fields

        * `city` - The city of the billing address.
        * `line1` - The first line of the billing address.
        * `line2` - The second line of the billing address.
        * `postal_code` - The postal code of the billing address.
        * `state` - The US state of the billing address.
      """

      defstruct [:city, :line1, :line2, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t() | nil,
              line1: String.t() | nil,
              line2: String.t() | nil,
              postal_code: String.t() | nil,
              state: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          line1: raw["line1"],
          line2: raw["line2"],
          postal_code: raw["postal_code"],
          state: raw["state"]
        }
      end
    end

    defmodule DigitalWallet do
      @moduledoc """
      The contact information used in the two-factor steps for digital wallet card
      creation. At least one field must be present to complete the digital wallet
      steps.

      ## Fields

        * `digital_card_profile_id` - The digital card profile assigned to this digital card.
          Card profiles may also be assigned at the program level.
        * `email` - An email address that can be used to verify the cardholder via one-time
          passcode over email.
        * `phone` - A phone number that can be used to verify the cardholder via one-time
          passcode over SMS.
      """

      defstruct [:digital_card_profile_id, :email, :phone]

      @type t :: %__MODULE__{
              digital_card_profile_id: String.t() | nil,
              email: String.t() | nil,
              phone: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          digital_card_profile_id: raw["digital_card_profile_id"],
          email: raw["email"],
          phone: raw["phone"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :authorization_controls,
      :billing_address,
      :bin,
      :created_at,
      :description,
      :digital_wallet,
      :entity_id,
      :expiration_month,
      :expiration_year,
      :idempotency_key,
      :last4,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            authorization_controls: AuthorizationControls.t() | nil,
            billing_address: BillingAddress.t(),
            bin: String.t(),
            created_at: DateTime.t(),
            description: String.t() | nil,
            digital_wallet: DigitalWallet.t() | nil,
            entity_id: String.t() | nil,
            expiration_month: integer(),
            expiration_year: integer(),
            idempotency_key: String.t() | nil,
            last4: String.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        authorization_controls:
          Increase.Decode.struct(raw["authorization_controls"], &AuthorizationControls.decode/1),
        billing_address: Increase.Decode.struct(raw["billing_address"], &BillingAddress.decode/1),
        bin: raw["bin"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        description: raw["description"],
        digital_wallet: Increase.Decode.struct(raw["digital_wallet"], &DigitalWallet.decode/1),
        entity_id: raw["entity_id"],
        expiration_month: raw["expiration_month"],
        expiration_year: raw["expiration_year"],
        idempotency_key: raw["idempotency_key"],
        last4: raw["last4"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  defmodule CardIframeURL do
    @moduledoc """
    An object containing the iframe URL for a Card.

    ## Fields

      * `expires_at` - The time the iframe URL will expire.
      * `iframe_url` - The iframe URL for the Card. Treat this as an opaque URL.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_iframe_url`.
    """

    defstruct [:expires_at, :iframe_url, :type]

    @type t :: %__MODULE__{
            expires_at: DateTime.t(),
            iframe_url: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        expires_at: Increase.Decode.datetime(raw["expires_at"]),
        iframe_url: raw["iframe_url"],
        type: raw["type"]
      }
    end
  end

  defmodule CardDetails do
    @moduledoc """
    An object containing the sensitive details (card number, CVC, PIN, etc) for
    a Card. These details are not included in the Card object. If you'd prefer
    to never access these details directly, you can use the [embedded
    iframe] to display the information
    to your users.

    ## Fields

      * `card_id` - The identifier for the Card for which sensitive details have been returned.
      * `expiration_month` - The month the card expires in M format (e.g., August is 8).
      * `expiration_year` - The year the card expires in YYYY format (e.g., 2025).
      * `pin` - The 4-digit PIN for the card, for use with ATMs.
      * `primary_account_number` - The card number.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_details`.
      * `verification_code` - The three-digit verification code for the card. It's also known as
        the Card Verification Code (CVC), the Card Verification Value
        (CVV), or the Card Identification (CID).
    """

    defstruct [
      :card_id,
      :expiration_month,
      :expiration_year,
      :pin,
      :primary_account_number,
      :type,
      :verification_code
    ]

    @type t :: %__MODULE__{
            card_id: String.t(),
            expiration_month: integer(),
            expiration_year: integer(),
            pin: String.t(),
            primary_account_number: String.t(),
            type: String.t(),
            verification_code: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        card_id: raw["card_id"],
        expiration_month: raw["expiration_month"],
        expiration_year: raw["expiration_year"],
        pin: raw["pin"],
        primary_account_number: raw["primary_account_number"],
        type: raw["type"],
        verification_code: raw["verification_code"]
      }
    end
  end

  @doc """
  Create a Card

  `POST /cards`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Card.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/cards"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Card.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Card

  `GET /cards/{card_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Card.t()} | {:error, Increase.Error.t()}
  def retrieve(client, card_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/cards/#{card_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Card.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update a Card

  `PATCH /cards/{card_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Card.t()} | {:error, Increase.Error.t()}
  def update(client, card_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/cards/#{card_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Card.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Cards

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  Card{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /cards`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/cards"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &Card.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Create an iframe URL for a Card to display the card details. More details
  about styling and usage can be found in the
  [documentation].

  `POST /cards/{card_id}/create_details_iframe`
  """
  @spec new_details_iframe(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, CardIframeURL.t()} | {:error, Increase.Error.t()}
  def new_details_iframe(client, card_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/cards/#{card_id}/create_details_iframe"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CardIframeURL.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Sensitive details for a Card include the primary account number, expiry,
  card verification code, and PIN.

  `GET /cards/{card_id}/details`
  """
  @spec details(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardDetails.t()} | {:error, Increase.Error.t()}
  def details(client, card_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/cards/#{card_id}/details"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardDetails.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update a Card's PIN

  `POST /cards/{card_id}/update_pin`
  """
  @spec update_pin(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, CardDetails.t()} | {:error, Increase.Error.t()}
  def update_pin(client, card_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/cards/#{card_id}/update_pin"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CardDetails.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
