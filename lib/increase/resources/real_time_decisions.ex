defmodule Increase.RealTimeDecisions do
  @moduledoc """
  Real Time Decisions are created when your application needs to take action in
  real-time to some event such as a card authorization. For more information, see
  our
  [Real-Time Decisions guide](https://increase.com/documentation/real-time-decisions).

  See https://increase.com/documentation/api/real-time-decisions for the full API
  reference for this resource.
  """

  alias Increase.Client

  defmodule RealTimeDecision do
    @moduledoc """
    Real Time Decisions are created when your application needs to take action
    in real-time to some event such as a card authorization. For more
    information, see our [Real-Time Decisions
    guide](https://increase.com/documentation/real-time-decisions).

    ## Fields

      * `id` - The Real-Time Decision identifier.
      * `card_authentication` - Fields related to a 3DS authentication attempt.
      * `card_authentication_challenge` - Fields related to a 3DS authentication attempt.
      * `card_authorization` - Fields related to a card authorization.
      * `card_balance_inquiry` - Fields related to a card balance inquiry.
      * `category` - The category of the Real-Time Decision.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Real-Time Decision was created.
      * `digital_wallet_authentication` - Fields related to a digital wallet authentication
        attempt.
      * `digital_wallet_token` - Fields related to a digital wallet token provisioning attempt.
      * `status` - The status of the Real-Time Decision.
      * `timeout_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which your application can no longer respond to the Real-Time Decision.
      * `type` - A constant representing the object's type. For this resource it will always be
        `real_time_decision`.
    """

    defmodule CardAuthentication do
      @moduledoc """
      Fields related to a 3DS authentication attempt.

      ## Fields

        * `access_control_server_transaction_identifier` - A unique identifier assigned by the
          Access Control Server (us) for this
          transaction.
        * `account_id` - The identifier of the Account the card belongs to.
        * `billing_address_city` - The city of the cardholder billing address associated with
          the card used for this purchase.
        * `billing_address_country` - The country of the cardholder billing address associated
          with the card used for this purchase.
        * `billing_address_line1` - The first line of the cardholder billing address associated
          with the card used for this purchase.
        * `billing_address_line2` - The second line of the cardholder billing address associated
          with the card used for this purchase.
        * `billing_address_line3` - The third line of the cardholder billing address associated
          with the card used for this purchase.
        * `billing_address_postal_code` - The postal code of the cardholder billing address
          associated with the card used for this purchase.
        * `billing_address_state` - The US state of the cardholder billing address associated
          with the card used for this purchase.
        * `card_id` - The identifier of the Card.
        * `cardholder_email` - The email address of the cardholder.
        * `cardholder_name` - The name of the cardholder.
        * `decision` - Whether or not the authentication attempt was approved.
        * `device_channel` - The device channel of the card authentication attempt.
        * `directory_server_transaction_identifier` - A unique identifier assigned by the
          Directory Server (the card network) for
          this transaction.
        * `merchant_acceptor_id` - The merchant identifier (commonly abbreviated as MID) of the
          merchant the card is transacting with.
        * `merchant_category_code` - The Merchant Category Code (commonly abbreviated as MCC) of
          the merchant the card is transacting with.
        * `merchant_country` - The country the merchant resides in.
        * `merchant_name` - The name of the merchant.
        * `message_category` - The message category of the card authentication attempt.
        * `prior_authenticated_card_payment_id` - The ID of a prior Card Authentication that the
          requestor used to authenticate this cardholder
          for a previous transaction.
        * `requestor_authentication_indicator` - The 3DS requestor authentication indicator
          describes why the authentication attempt is
          performed, such as for a recurring transaction.
        * `requestor_challenge_indicator` - Indicates whether a challenge is requested for this
          transaction.
        * `requestor_name` - The name of the 3DS requestor.
        * `requestor_url` - The URL of the 3DS requestor.
        * `shipping_address_city` - The city of the shipping address associated with this
          purchase.
        * `shipping_address_country` - The country of the shipping address associated with this
          purchase.
        * `shipping_address_line1` - The first line of the shipping address associated with this
          purchase.
        * `shipping_address_line2` - The second line of the shipping address associated with
          this purchase.
        * `shipping_address_line3` - The third line of the shipping address associated with this
          purchase.
        * `shipping_address_postal_code` - The postal code of the shipping address associated
          with this purchase.
        * `shipping_address_state` - The US state of the shipping address associated with this
          purchase.
        * `three_d_secure_server_transaction_identifier` - A unique identifier assigned by the
          3DS Server initiating the
          authentication attempt for this
          transaction.
        * `upcoming_card_payment_id` - The identifier of the Card Payment this authentication
          attempt will belong to. Available in the API once the
          card authentication has completed.
      """

      defmodule DeviceChannel do
        @moduledoc """
        The device channel of the card authentication attempt.

        ## Fields

          * `browser` - Fields specific to the browser device channel.
          * `category` - The category of the device channel.
          * `merchant_initiated` - Fields specific to merchant initiated transactions.
        """

        defmodule Browser do
          @moduledoc """
          Fields specific to the browser device channel.

          ## Fields

            * `accept_header` - The accept header from the cardholder's browser.
            * `ip_address` - The IP address of the cardholder's browser.
            * `javascript_enabled` - Whether JavaScript is enabled in the cardholder's browser.
            * `language` - The language of the cardholder's browser.
            * `user_agent` - The user agent of the cardholder's browser.
          """

          defstruct [:accept_header, :ip_address, :javascript_enabled, :language, :user_agent]

          @type t :: %__MODULE__{
                  accept_header: String.t() | nil,
                  ip_address: String.t() | nil,
                  javascript_enabled: String.t() | nil,
                  language: String.t() | nil,
                  user_agent: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              accept_header: raw["accept_header"],
              ip_address: raw["ip_address"],
              javascript_enabled: raw["javascript_enabled"],
              language: raw["language"],
              user_agent: raw["user_agent"]
            }
          end
        end

        defmodule MerchantInitiated do
          @moduledoc """
          Fields specific to merchant initiated transactions.

          ## Fields

            * `indicator` - The merchant initiated indicator for the transaction.
          """

          defstruct [:indicator]

          @type t :: %__MODULE__{
                  indicator: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              indicator: raw["indicator"]
            }
          end
        end

        defstruct [:browser, :category, :merchant_initiated]

        @type t :: %__MODULE__{
                browser: Browser.t() | nil,
                category: String.t(),
                merchant_initiated: MerchantInitiated.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            browser: Increase.Decode.struct(raw["browser"], &Browser.decode/1),
            category: raw["category"],
            merchant_initiated:
              Increase.Decode.struct(raw["merchant_initiated"], &MerchantInitiated.decode/1)
          }
        end
      end

      defmodule MessageCategory do
        @moduledoc """
        The message category of the card authentication attempt.

        ## Fields

          * `category` - The category of the card authentication attempt.
          * `non_payment` - Fields specific to non-payment authentication attempts.
          * `payment` - Fields specific to payment authentication attempts.
        """

        defmodule NonPayment do
          @moduledoc """
          Fields specific to non-payment authentication attempts.

          ## Fields

          """

          defstruct []

          @type t :: %__MODULE__{}

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{}
          end
        end

        defmodule Payment do
          @moduledoc """
          Fields specific to payment authentication attempts.

          ## Fields

            * `purchase_amount` - The purchase amount in minor units.
            * `purchase_amount_cardholder_estimated` - The purchase amount in the cardholder's
              currency (i.e., USD) estimated using
              daily conversion rates from the card
              network.
            * `purchase_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code
              for the authentication attempt's purchase currency.
            * `transaction_type` - The type of transaction being authenticated.
          """

          defstruct [
            :purchase_amount,
            :purchase_amount_cardholder_estimated,
            :purchase_currency,
            :transaction_type
          ]

          @type t :: %__MODULE__{
                  purchase_amount: integer(),
                  purchase_amount_cardholder_estimated: integer() | nil,
                  purchase_currency: String.t(),
                  transaction_type: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              purchase_amount: raw["purchase_amount"],
              purchase_amount_cardholder_estimated: raw["purchase_amount_cardholder_estimated"],
              purchase_currency: raw["purchase_currency"],
              transaction_type: raw["transaction_type"]
            }
          end
        end

        defstruct [:category, :non_payment, :payment]

        @type t :: %__MODULE__{
                category: String.t(),
                non_payment: NonPayment.t() | nil,
                payment: Payment.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            category: raw["category"],
            non_payment: Increase.Decode.struct(raw["non_payment"], &NonPayment.decode/1),
            payment: Increase.Decode.struct(raw["payment"], &Payment.decode/1)
          }
        end
      end

      defstruct [
        :access_control_server_transaction_identifier,
        :account_id,
        :billing_address_city,
        :billing_address_country,
        :billing_address_line1,
        :billing_address_line2,
        :billing_address_line3,
        :billing_address_postal_code,
        :billing_address_state,
        :card_id,
        :cardholder_email,
        :cardholder_name,
        :decision,
        :device_channel,
        :directory_server_transaction_identifier,
        :merchant_acceptor_id,
        :merchant_category_code,
        :merchant_country,
        :merchant_name,
        :message_category,
        :prior_authenticated_card_payment_id,
        :requestor_authentication_indicator,
        :requestor_challenge_indicator,
        :requestor_name,
        :requestor_url,
        :shipping_address_city,
        :shipping_address_country,
        :shipping_address_line1,
        :shipping_address_line2,
        :shipping_address_line3,
        :shipping_address_postal_code,
        :shipping_address_state,
        :three_d_secure_server_transaction_identifier,
        :upcoming_card_payment_id
      ]

      @type t :: %__MODULE__{
              access_control_server_transaction_identifier: String.t(),
              account_id: String.t(),
              billing_address_city: String.t() | nil,
              billing_address_country: String.t() | nil,
              billing_address_line1: String.t() | nil,
              billing_address_line2: String.t() | nil,
              billing_address_line3: String.t() | nil,
              billing_address_postal_code: String.t() | nil,
              billing_address_state: String.t() | nil,
              card_id: String.t(),
              cardholder_email: String.t() | nil,
              cardholder_name: String.t() | nil,
              decision: String.t() | nil,
              device_channel: DeviceChannel.t(),
              directory_server_transaction_identifier: String.t(),
              merchant_acceptor_id: String.t() | nil,
              merchant_category_code: String.t() | nil,
              merchant_country: String.t() | nil,
              merchant_name: String.t() | nil,
              message_category: MessageCategory.t(),
              prior_authenticated_card_payment_id: String.t() | nil,
              requestor_authentication_indicator: String.t() | nil,
              requestor_challenge_indicator: String.t() | nil,
              requestor_name: String.t(),
              requestor_url: String.t(),
              shipping_address_city: String.t() | nil,
              shipping_address_country: String.t() | nil,
              shipping_address_line1: String.t() | nil,
              shipping_address_line2: String.t() | nil,
              shipping_address_line3: String.t() | nil,
              shipping_address_postal_code: String.t() | nil,
              shipping_address_state: String.t() | nil,
              three_d_secure_server_transaction_identifier: String.t(),
              upcoming_card_payment_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          access_control_server_transaction_identifier:
            raw["access_control_server_transaction_identifier"],
          account_id: raw["account_id"],
          billing_address_city: raw["billing_address_city"],
          billing_address_country: raw["billing_address_country"],
          billing_address_line1: raw["billing_address_line1"],
          billing_address_line2: raw["billing_address_line2"],
          billing_address_line3: raw["billing_address_line3"],
          billing_address_postal_code: raw["billing_address_postal_code"],
          billing_address_state: raw["billing_address_state"],
          card_id: raw["card_id"],
          cardholder_email: raw["cardholder_email"],
          cardholder_name: raw["cardholder_name"],
          decision: raw["decision"],
          device_channel: Increase.Decode.struct(raw["device_channel"], &DeviceChannel.decode/1),
          directory_server_transaction_identifier: raw["directory_server_transaction_identifier"],
          merchant_acceptor_id: raw["merchant_acceptor_id"],
          merchant_category_code: raw["merchant_category_code"],
          merchant_country: raw["merchant_country"],
          merchant_name: raw["merchant_name"],
          message_category:
            Increase.Decode.struct(raw["message_category"], &MessageCategory.decode/1),
          prior_authenticated_card_payment_id: raw["prior_authenticated_card_payment_id"],
          requestor_authentication_indicator: raw["requestor_authentication_indicator"],
          requestor_challenge_indicator: raw["requestor_challenge_indicator"],
          requestor_name: raw["requestor_name"],
          requestor_url: raw["requestor_url"],
          shipping_address_city: raw["shipping_address_city"],
          shipping_address_country: raw["shipping_address_country"],
          shipping_address_line1: raw["shipping_address_line1"],
          shipping_address_line2: raw["shipping_address_line2"],
          shipping_address_line3: raw["shipping_address_line3"],
          shipping_address_postal_code: raw["shipping_address_postal_code"],
          shipping_address_state: raw["shipping_address_state"],
          three_d_secure_server_transaction_identifier:
            raw["three_d_secure_server_transaction_identifier"],
          upcoming_card_payment_id: raw["upcoming_card_payment_id"]
        }
      end
    end

    defmodule CardAuthenticationChallenge do
      @moduledoc """
      Fields related to a 3DS authentication attempt.

      ## Fields

        * `account_id` - The identifier of the Account the card belongs to.
        * `card_id` - The identifier of the Card that is being tokenized.
        * `card_payment_id` - The identifier of the Card Payment this authentication challenge
          attempt belongs to.
        * `one_time_code` - The one-time code delivered to the cardholder.
        * `result` - Whether or not the challenge was delivered to the cardholder.
      """

      defstruct [:account_id, :card_id, :card_payment_id, :one_time_code, :result]

      @type t :: %__MODULE__{
              account_id: String.t(),
              card_id: String.t(),
              card_payment_id: String.t(),
              one_time_code: String.t(),
              result: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          card_id: raw["card_id"],
          card_payment_id: raw["card_payment_id"],
          one_time_code: raw["one_time_code"],
          result: raw["result"]
        }
      end
    end

    defmodule CardAuthorization do
      @moduledoc """
      Fields related to a card authorization.

      ## Fields

        * `account_id` - The identifier of the Account the authorization will debit.
        * `additional_amounts` - Additional amounts associated with the card authorization, such
          as ATM surcharges fees. These are usually a subset of the
          `amount` field and are used to provide more detailed
          information about the transaction.
        * `approval` - Present if and only if `decision` is `approve`. Contains information
          related to the approval of the authorization.
        * `card_id` - The identifier of the Card that is being authorized.
        * `decision` - Whether or not the authorization was approved.
        * `decline` - Present if and only if `decision` is `decline`. Contains information
          related to the reason the authorization was declined.
        * `digital_wallet_token_id` - If the authorization was made via a Digital Wallet Token
          (such as an Apple Pay purchase), the identifier of the
          token that was used.
        * `direction` - The direction describes the direction the funds will move, either from
          the cardholder to the merchant or from the merchant to the cardholder.
        * `healthcare` - The healthcare-related fields for this authorization. Only present for
          specific programs.
        * `merchant_acceptor_id` - The merchant identifier (commonly abbreviated as MID) of the
          merchant the card is transacting with.
        * `merchant_category_code` - The Merchant Category Code (commonly abbreviated as MCC) of
          the merchant the card is transacting with.
        * `merchant_city` - The city the merchant resides in.
        * `merchant_country` - The country the merchant resides in.
        * `merchant_descriptor` - The merchant descriptor of the merchant the card is
          transacting with.
        * `merchant_postal_code` - The merchant's postal code. For US merchants this is either a
          5-digit or 9-digit ZIP code, where the first 5 and last 4 are
          separated by a dash.
        * `merchant_state` - The state the merchant resides in.
        * `network_details` - Fields specific to the `network`.
        * `network_identifiers` - Network-specific identifiers for a specific request or
          transaction.
        * `network_risk_score` - The risk score generated by the card network. For Visa this is
          the Visa Advanced Authorization risk score, from 0 to 99, where
          99 is the riskiest. For Pulse the score is from 0 to 999, where
          999 is the riskiest.
        * `partial_approval_capability` - Whether or not the authorization supports partial
          approvals.
        * `physical_card_id` - If the authorization was made in-person with a physical card, the
          Physical Card that was used.
        * `presentment_amount` - The amount of the attempted authorization in the currency the
          card user sees at the time of purchase, in the minor unit of
          that currency. For dollars, for example, this is cents.
        * `presentment_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code
          for the currency the user sees at the time of purchase.
        * `processing_category` - The processing category describes the intent behind the
          authorization, such as whether it was used for bill payments
          or an automatic fuel dispenser.
        * `request_details` - Fields specific to the type of request, such as an incremental
          authorization.
        * `settlement_amount` - The amount of the attempted authorization in the currency it
          will be settled in. This currency is the same as that of the
          Account the card belongs to.
        * `settlement_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code
          for the currency the transaction will be settled in.
        * `terminal_id` - The terminal identifier (commonly abbreviated as TID) of the terminal
          the card is transacting with.
        * `upcoming_card_payment_id` - The identifier of the Card Payment this authorization
          will belong to. Available in the API once the card
          authorization has completed.
        * `verification` - Fields related to verification of cardholder-provided values.
      """

      defmodule AdditionalAmounts do
        @moduledoc """
        Additional amounts associated with the card authorization, such as ATM
        surcharges fees. These are usually a subset of the `amount` field and are
        used to provide more detailed information about the transaction.

        ## Fields

          * `clinic` - The part of this transaction amount that was for clinic-related services.
          * `dental` - The part of this transaction amount that was for dental-related services.
          * `original` - The original pre-authorized amount.
          * `prescription` - The part of this transaction amount that was for healthcare
            prescriptions.
          * `surcharge` - The surcharge amount charged for this transaction by the merchant.
          * `total_cumulative` - The total amount of a series of incremental authorizations,
            optionally provided.
          * `total_healthcare` - The total amount of healthcare-related additional amounts.
          * `transit` - The part of this transaction amount that was for transit-related
            services.
          * `unknown` - An unknown additional amount.
          * `vision` - The part of this transaction amount that was for vision-related services.
        """

        defmodule Clinic do
          @moduledoc """
          The part of this transaction amount that was for clinic-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Dental do
          @moduledoc """
          The part of this transaction amount that was for dental-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Original do
          @moduledoc """
          The original pre-authorized amount.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Prescription do
          @moduledoc """
          The part of this transaction amount that was for healthcare prescriptions.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Surcharge do
          @moduledoc """
          The surcharge amount charged for this transaction by the merchant.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule TotalCumulative do
          @moduledoc """
          The total amount of a series of incremental authorizations, optionally
          provided.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule TotalHealthcare do
          @moduledoc """
          The total amount of healthcare-related additional amounts.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Transit do
          @moduledoc """
          The part of this transaction amount that was for transit-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Unknown do
          @moduledoc """
          An unknown additional amount.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Vision do
          @moduledoc """
          The part of this transaction amount that was for vision-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defstruct [
          :clinic,
          :dental,
          :original,
          :prescription,
          :surcharge,
          :total_cumulative,
          :total_healthcare,
          :transit,
          :unknown,
          :vision
        ]

        @type t :: %__MODULE__{
                clinic: Clinic.t() | nil,
                dental: Dental.t() | nil,
                original: Original.t() | nil,
                prescription: Prescription.t() | nil,
                surcharge: Surcharge.t() | nil,
                total_cumulative: TotalCumulative.t() | nil,
                total_healthcare: TotalHealthcare.t() | nil,
                transit: Transit.t() | nil,
                unknown: Unknown.t() | nil,
                vision: Vision.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            clinic: Increase.Decode.struct(raw["clinic"], &Clinic.decode/1),
            dental: Increase.Decode.struct(raw["dental"], &Dental.decode/1),
            original: Increase.Decode.struct(raw["original"], &Original.decode/1),
            prescription: Increase.Decode.struct(raw["prescription"], &Prescription.decode/1),
            surcharge: Increase.Decode.struct(raw["surcharge"], &Surcharge.decode/1),
            total_cumulative:
              Increase.Decode.struct(raw["total_cumulative"], &TotalCumulative.decode/1),
            total_healthcare:
              Increase.Decode.struct(raw["total_healthcare"], &TotalHealthcare.decode/1),
            transit: Increase.Decode.struct(raw["transit"], &Transit.decode/1),
            unknown: Increase.Decode.struct(raw["unknown"], &Unknown.decode/1),
            vision: Increase.Decode.struct(raw["vision"], &Vision.decode/1)
          }
        end
      end

      defmodule Approval do
        @moduledoc """
        Present if and only if `decision` is `approve`. Contains information related
        to the approval of the authorization.

        ## Fields

          * `partial_amount` - If the authorization was partially approved, this field contains
            the approved amount in the minor unit of the settlement currency.
        """

        defstruct [:partial_amount]

        @type t :: %__MODULE__{
                partial_amount: integer() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            partial_amount: raw["partial_amount"]
          }
        end
      end

      defmodule Decline do
        @moduledoc """
        Present if and only if `decision` is `decline`. Contains information related
        to the reason the authorization was declined.

        ## Fields

          * `reason` - The reason the authorization was declined.
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

      defmodule Healthcare do
        @moduledoc """
        The healthcare-related fields for this authorization. Only present for
        specific programs.

        ## Fields

          * `merchant_ninety_percent_eligibility` - The merchant's eligibility under the
            Internal Revenue Service's 90% Rule for
            Flexible Spending Account (FSA) and Health
            Savings Account (HSA) eligible products. The
            eligibility is determined based on the list
            of merchants maintained by the Special
            Interest Group for IIAS Standards (SIGIS).
        """

        defstruct [:merchant_ninety_percent_eligibility]

        @type t :: %__MODULE__{
                merchant_ninety_percent_eligibility: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            merchant_ninety_percent_eligibility: raw["merchant_ninety_percent_eligibility"]
          }
        end
      end

      defmodule NetworkDetails do
        @moduledoc """
        Fields specific to the `network`.

        ## Fields

          * `category` - The payment network used to process this card authorization.
          * `pulse` - Fields specific to the `pulse` network.
          * `visa` - Fields specific to the `visa` network.
        """

        defmodule Pulse do
          @moduledoc """
          Fields specific to the `pulse` network.

          ## Fields

          """

          defstruct []

          @type t :: %__MODULE__{}

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{}
          end
        end

        defmodule Visa do
          @moduledoc """
          Fields specific to the `visa` network.

          ## Fields

            * `electronic_commerce_indicator` - For electronic commerce transactions, this
              identifies the level of security used in
              obtaining the customer's payment credential. For
              mail or telephone order transactions, identifies
              the type of mail or telephone order.
            * `point_of_service_entry_mode` - The method used to enter the cardholder's primary
              account number and card expiration date.
            * `stand_in_processing_reason` - Only present when `actioner: network`. Describes
              why a card authorization was approved or declined
              by Visa through stand-in processing.
            * `terminal_entry_capability` - The capability of the terminal being used to read
              the card. Shows whether a terminal can e.g., accept
              chip cards or if it only supports magnetic stripe
              reads. This reflects the highest capability of the
              terminal — for example, a terminal that supports
              both chip and magnetic stripe will be identified as
              chip-capable.
          """

          defstruct [
            :electronic_commerce_indicator,
            :point_of_service_entry_mode,
            :stand_in_processing_reason,
            :terminal_entry_capability
          ]

          @type t :: %__MODULE__{
                  electronic_commerce_indicator: String.t() | nil,
                  point_of_service_entry_mode: String.t() | nil,
                  stand_in_processing_reason: String.t() | nil,
                  terminal_entry_capability: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              electronic_commerce_indicator: raw["electronic_commerce_indicator"],
              point_of_service_entry_mode: raw["point_of_service_entry_mode"],
              stand_in_processing_reason: raw["stand_in_processing_reason"],
              terminal_entry_capability: raw["terminal_entry_capability"]
            }
          end
        end

        defstruct [:category, :pulse, :visa]

        @type t :: %__MODULE__{
                category: String.t(),
                pulse: Pulse.t() | nil,
                visa: Visa.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            category: raw["category"],
            pulse: Increase.Decode.struct(raw["pulse"], &Pulse.decode/1),
            visa: Increase.Decode.struct(raw["visa"], &Visa.decode/1)
          }
        end
      end

      defmodule NetworkIdentifiers do
        @moduledoc """
        Network-specific identifiers for a specific request or transaction.

        ## Fields

          * `authorization_identification_response` - The randomly generated 6-character
            Authorization Identification Response code
            sent back to the acquirer in an approved
            response.
          * `retrieval_reference_number` - A life-cycle identifier used across e.g., an
            authorization and a reversal. Expected to be unique
            per acquirer within a window of time. For some card
            networks the retrieval reference number includes the
            trace counter.
          * `trace_number` - A counter used to verify an individual authorization. Expected to
            be unique per acquirer within a window of time.
          * `transaction_id` - A globally unique transaction identifier provided by the card
            network, used across multiple life-cycle requests.
        """

        defstruct [
          :authorization_identification_response,
          :retrieval_reference_number,
          :trace_number,
          :transaction_id
        ]

        @type t :: %__MODULE__{
                authorization_identification_response: String.t() | nil,
                retrieval_reference_number: String.t() | nil,
                trace_number: String.t() | nil,
                transaction_id: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            authorization_identification_response: raw["authorization_identification_response"],
            retrieval_reference_number: raw["retrieval_reference_number"],
            trace_number: raw["trace_number"],
            transaction_id: raw["transaction_id"]
          }
        end
      end

      defmodule RequestDetails do
        @moduledoc """
        Fields specific to the type of request, such as an incremental
        authorization.

        ## Fields

          * `category` - The type of this request (e.g., an initial authorization or an
            incremental authorization).
          * `incremental_authorization` - Fields specific to the category
            `incremental_authorization`.
          * `initial_authorization` - Fields specific to the category `initial_authorization`.
        """

        defmodule IncrementalAuthorization do
          @moduledoc """
          Fields specific to the category `incremental_authorization`.

          ## Fields

            * `card_payment_id` - The card payment for this authorization and increment.
            * `original_card_authorization_id` - The identifier of the card authorization this
              request is attempting to increment.
          """

          defstruct [:card_payment_id, :original_card_authorization_id]

          @type t :: %__MODULE__{
                  card_payment_id: String.t(),
                  original_card_authorization_id: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              card_payment_id: raw["card_payment_id"],
              original_card_authorization_id: raw["original_card_authorization_id"]
            }
          end
        end

        defmodule InitialAuthorization do
          @moduledoc """
          Fields specific to the category `initial_authorization`.

          ## Fields

          """

          defstruct []

          @type t :: %__MODULE__{}

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{}
          end
        end

        defstruct [:category, :incremental_authorization, :initial_authorization]

        @type t :: %__MODULE__{
                category: String.t(),
                incremental_authorization: IncrementalAuthorization.t() | nil,
                initial_authorization: InitialAuthorization.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            category: raw["category"],
            incremental_authorization:
              Increase.Decode.struct(
                raw["incremental_authorization"],
                &IncrementalAuthorization.decode/1
              ),
            initial_authorization:
              Increase.Decode.struct(raw["initial_authorization"], &InitialAuthorization.decode/1)
          }
        end
      end

      defmodule Verification do
        @moduledoc """
        Fields related to verification of cardholder-provided values.

        ## Fields

          * `card_verification_code` - Fields related to verification of the Card Verification
            Code, a 3-digit code on the back of the card.
          * `cardholder_address` - Cardholder address provided in the authorization request and
            the address on file we verified it against.
          * `cardholder_name` - Cardholder name provided in the authorization request.
        """

        defmodule CardVerificationCode do
          @moduledoc """
          Fields related to verification of the Card Verification Code, a 3-digit code
          on the back of the card.

          ## Fields

            * `result` - The result of verifying the Card Verification Code.
          """

          defstruct [:result]

          @type t :: %__MODULE__{
                  result: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              result: raw["result"]
            }
          end
        end

        defmodule CardholderAddress do
          @moduledoc """
          Cardholder address provided in the authorization request and the address on
          file we verified it against.

          ## Fields

            * `actual_line1` - Line 1 of the address on file for the cardholder.
            * `actual_postal_code` - The postal code of the address on file for the cardholder.
            * `provided_line1` - The cardholder address line 1 provided for verification in the
              authorization request.
            * `provided_postal_code` - The postal code provided for verification in the
              authorization request.
            * `result` - The address verification result returned to the card network.
          """

          defstruct [
            :actual_line1,
            :actual_postal_code,
            :provided_line1,
            :provided_postal_code,
            :result
          ]

          @type t :: %__MODULE__{
                  actual_line1: String.t() | nil,
                  actual_postal_code: String.t() | nil,
                  provided_line1: String.t() | nil,
                  provided_postal_code: String.t() | nil,
                  result: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              actual_line1: raw["actual_line1"],
              actual_postal_code: raw["actual_postal_code"],
              provided_line1: raw["provided_line1"],
              provided_postal_code: raw["provided_postal_code"],
              result: raw["result"]
            }
          end
        end

        defmodule CardholderName do
          @moduledoc """
          Cardholder name provided in the authorization request.

          ## Fields

            * `provided_first_name` - The first name provided for verification in the
              authorization request.
            * `provided_last_name` - The last name provided for verification in the
              authorization request.
            * `provided_middle_name` - The middle name provided for verification in the
              authorization request.
          """

          defstruct [:provided_first_name, :provided_last_name, :provided_middle_name]

          @type t :: %__MODULE__{
                  provided_first_name: String.t() | nil,
                  provided_last_name: String.t() | nil,
                  provided_middle_name: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              provided_first_name: raw["provided_first_name"],
              provided_last_name: raw["provided_last_name"],
              provided_middle_name: raw["provided_middle_name"]
            }
          end
        end

        defstruct [:card_verification_code, :cardholder_address, :cardholder_name]

        @type t :: %__MODULE__{
                card_verification_code: CardVerificationCode.t(),
                cardholder_address: CardholderAddress.t(),
                cardholder_name: CardholderName.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            card_verification_code:
              Increase.Decode.struct(
                raw["card_verification_code"],
                &CardVerificationCode.decode/1
              ),
            cardholder_address:
              Increase.Decode.struct(raw["cardholder_address"], &CardholderAddress.decode/1),
            cardholder_name:
              Increase.Decode.struct(raw["cardholder_name"], &CardholderName.decode/1)
          }
        end
      end

      defstruct [
        :account_id,
        :additional_amounts,
        :approval,
        :card_id,
        :decision,
        :decline,
        :digital_wallet_token_id,
        :direction,
        :healthcare,
        :merchant_acceptor_id,
        :merchant_category_code,
        :merchant_city,
        :merchant_country,
        :merchant_descriptor,
        :merchant_postal_code,
        :merchant_state,
        :network_details,
        :network_identifiers,
        :network_risk_score,
        :partial_approval_capability,
        :physical_card_id,
        :presentment_amount,
        :presentment_currency,
        :processing_category,
        :request_details,
        :settlement_amount,
        :settlement_currency,
        :terminal_id,
        :upcoming_card_payment_id,
        :verification
      ]

      @type t :: %__MODULE__{
              account_id: String.t(),
              additional_amounts: AdditionalAmounts.t(),
              approval: Approval.t() | nil,
              card_id: String.t(),
              decision: String.t() | nil,
              decline: Decline.t() | nil,
              digital_wallet_token_id: String.t() | nil,
              direction: String.t(),
              healthcare: Healthcare.t() | nil,
              merchant_acceptor_id: String.t(),
              merchant_category_code: String.t(),
              merchant_city: String.t() | nil,
              merchant_country: String.t(),
              merchant_descriptor: String.t(),
              merchant_postal_code: String.t() | nil,
              merchant_state: String.t() | nil,
              network_details: NetworkDetails.t(),
              network_identifiers: NetworkIdentifiers.t(),
              network_risk_score: integer() | nil,
              partial_approval_capability: String.t(),
              physical_card_id: String.t() | nil,
              presentment_amount: integer(),
              presentment_currency: String.t(),
              processing_category: String.t(),
              request_details: RequestDetails.t(),
              settlement_amount: integer(),
              settlement_currency: String.t(),
              terminal_id: String.t() | nil,
              upcoming_card_payment_id: String.t(),
              verification: Verification.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          additional_amounts:
            Increase.Decode.struct(raw["additional_amounts"], &AdditionalAmounts.decode/1),
          approval: Increase.Decode.struct(raw["approval"], &Approval.decode/1),
          card_id: raw["card_id"],
          decision: raw["decision"],
          decline: Increase.Decode.struct(raw["decline"], &Decline.decode/1),
          digital_wallet_token_id: raw["digital_wallet_token_id"],
          direction: raw["direction"],
          healthcare: Increase.Decode.struct(raw["healthcare"], &Healthcare.decode/1),
          merchant_acceptor_id: raw["merchant_acceptor_id"],
          merchant_category_code: raw["merchant_category_code"],
          merchant_city: raw["merchant_city"],
          merchant_country: raw["merchant_country"],
          merchant_descriptor: raw["merchant_descriptor"],
          merchant_postal_code: raw["merchant_postal_code"],
          merchant_state: raw["merchant_state"],
          network_details:
            Increase.Decode.struct(raw["network_details"], &NetworkDetails.decode/1),
          network_identifiers:
            Increase.Decode.struct(raw["network_identifiers"], &NetworkIdentifiers.decode/1),
          network_risk_score: raw["network_risk_score"],
          partial_approval_capability: raw["partial_approval_capability"],
          physical_card_id: raw["physical_card_id"],
          presentment_amount: raw["presentment_amount"],
          presentment_currency: raw["presentment_currency"],
          processing_category: raw["processing_category"],
          request_details:
            Increase.Decode.struct(raw["request_details"], &RequestDetails.decode/1),
          settlement_amount: raw["settlement_amount"],
          settlement_currency: raw["settlement_currency"],
          terminal_id: raw["terminal_id"],
          upcoming_card_payment_id: raw["upcoming_card_payment_id"],
          verification: Increase.Decode.struct(raw["verification"], &Verification.decode/1)
        }
      end
    end

    defmodule CardBalanceInquiry do
      @moduledoc """
      Fields related to a card balance inquiry.

      ## Fields

        * `account_id` - The identifier of the Account the authorization will debit.
        * `additional_amounts` - Additional amounts associated with the card authorization, such
          as ATM surcharges fees. These are usually a subset of the
          `amount` field and are used to provide more detailed
          information about the transaction.
        * `approval` - Present if and only if `decision` is `approve`. Contains information
          related to the approval of the balance inquiry.
        * `card_id` - The identifier of the Card that is being authorized.
        * `decision` - Whether or not the authorization was approved.
        * `digital_wallet_token_id` - If the authorization was made via a Digital Wallet Token
          (such as an Apple Pay purchase), the identifier of the
          token that was used.
        * `merchant_acceptor_id` - The merchant identifier (commonly abbreviated as MID) of the
          merchant the card is transacting with.
        * `merchant_category_code` - The Merchant Category Code (commonly abbreviated as MCC) of
          the merchant the card is transacting with.
        * `merchant_city` - The city the merchant resides in.
        * `merchant_country` - The country the merchant resides in.
        * `merchant_descriptor` - The merchant descriptor of the merchant the card is
          transacting with.
        * `merchant_postal_code` - The merchant's postal code. For US merchants this is either a
          5-digit or 9-digit ZIP code, where the first 5 and last 4 are
          separated by a dash.
        * `merchant_state` - The state the merchant resides in.
        * `network_details` - Fields specific to the `network`.
        * `network_identifiers` - Network-specific identifiers for a specific request or
          transaction.
        * `network_risk_score` - The risk score generated by the card network. For Visa this is
          the Visa Advanced Authorization risk score, from 0 to 99, where
          99 is the riskiest. For Pulse the score is from 0 to 999, where
          999 is the riskiest.
        * `physical_card_id` - If the authorization was made in-person with a physical card, the
          Physical Card that was used.
        * `terminal_id` - The terminal identifier (commonly abbreviated as TID) of the terminal
          the card is transacting with.
        * `upcoming_card_payment_id` - The identifier of the Card Payment this authorization
          will belong to. Available in the API once the card
          authorization has completed.
        * `verification` - Fields related to verification of cardholder-provided values.
      """

      defmodule AdditionalAmounts do
        @moduledoc """
        Additional amounts associated with the card authorization, such as ATM
        surcharges fees. These are usually a subset of the `amount` field and are
        used to provide more detailed information about the transaction.

        ## Fields

          * `clinic` - The part of this transaction amount that was for clinic-related services.
          * `dental` - The part of this transaction amount that was for dental-related services.
          * `original` - The original pre-authorized amount.
          * `prescription` - The part of this transaction amount that was for healthcare
            prescriptions.
          * `surcharge` - The surcharge amount charged for this transaction by the merchant.
          * `total_cumulative` - The total amount of a series of incremental authorizations,
            optionally provided.
          * `total_healthcare` - The total amount of healthcare-related additional amounts.
          * `transit` - The part of this transaction amount that was for transit-related
            services.
          * `unknown` - An unknown additional amount.
          * `vision` - The part of this transaction amount that was for vision-related services.
        """

        defmodule Clinic do
          @moduledoc """
          The part of this transaction amount that was for clinic-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Dental do
          @moduledoc """
          The part of this transaction amount that was for dental-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Original do
          @moduledoc """
          The original pre-authorized amount.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Prescription do
          @moduledoc """
          The part of this transaction amount that was for healthcare prescriptions.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Surcharge do
          @moduledoc """
          The surcharge amount charged for this transaction by the merchant.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule TotalCumulative do
          @moduledoc """
          The total amount of a series of incremental authorizations, optionally
          provided.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule TotalHealthcare do
          @moduledoc """
          The total amount of healthcare-related additional amounts.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Transit do
          @moduledoc """
          The part of this transaction amount that was for transit-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Unknown do
          @moduledoc """
          An unknown additional amount.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defmodule Vision do
          @moduledoc """
          The part of this transaction amount that was for vision-related services.

          ## Fields

            * `amount` - The amount in minor units of the `currency` field. The amount is
              positive if it is added to the amount (such as an ATM surcharge fee)
              and negative if it is subtracted from the amount (such as a discount).
            * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
              additional amount's currency.
          """

          defstruct [:amount, :currency]

          @type t :: %__MODULE__{
                  amount: integer(),
                  currency: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              amount: raw["amount"],
              currency: raw["currency"]
            }
          end
        end

        defstruct [
          :clinic,
          :dental,
          :original,
          :prescription,
          :surcharge,
          :total_cumulative,
          :total_healthcare,
          :transit,
          :unknown,
          :vision
        ]

        @type t :: %__MODULE__{
                clinic: Clinic.t() | nil,
                dental: Dental.t() | nil,
                original: Original.t() | nil,
                prescription: Prescription.t() | nil,
                surcharge: Surcharge.t() | nil,
                total_cumulative: TotalCumulative.t() | nil,
                total_healthcare: TotalHealthcare.t() | nil,
                transit: Transit.t() | nil,
                unknown: Unknown.t() | nil,
                vision: Vision.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            clinic: Increase.Decode.struct(raw["clinic"], &Clinic.decode/1),
            dental: Increase.Decode.struct(raw["dental"], &Dental.decode/1),
            original: Increase.Decode.struct(raw["original"], &Original.decode/1),
            prescription: Increase.Decode.struct(raw["prescription"], &Prescription.decode/1),
            surcharge: Increase.Decode.struct(raw["surcharge"], &Surcharge.decode/1),
            total_cumulative:
              Increase.Decode.struct(raw["total_cumulative"], &TotalCumulative.decode/1),
            total_healthcare:
              Increase.Decode.struct(raw["total_healthcare"], &TotalHealthcare.decode/1),
            transit: Increase.Decode.struct(raw["transit"], &Transit.decode/1),
            unknown: Increase.Decode.struct(raw["unknown"], &Unknown.decode/1),
            vision: Increase.Decode.struct(raw["vision"], &Vision.decode/1)
          }
        end
      end

      defmodule Approval do
        @moduledoc """
        Present if and only if `decision` is `approve`. Contains information related
        to the approval of the balance inquiry.

        ## Fields

          * `balance` - If the balance inquiry was approved, this field contains the balance in
            the minor unit of the settlement currency.
        """

        defstruct [:balance]

        @type t :: %__MODULE__{
                balance: integer()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            balance: raw["balance"]
          }
        end
      end

      defmodule NetworkDetails do
        @moduledoc """
        Fields specific to the `network`.

        ## Fields

          * `category` - The payment network used to process this card authorization.
          * `pulse` - Fields specific to the `pulse` network.
          * `visa` - Fields specific to the `visa` network.
        """

        defmodule Pulse do
          @moduledoc """
          Fields specific to the `pulse` network.

          ## Fields

          """

          defstruct []

          @type t :: %__MODULE__{}

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{}
          end
        end

        defmodule Visa do
          @moduledoc """
          Fields specific to the `visa` network.

          ## Fields

            * `electronic_commerce_indicator` - For electronic commerce transactions, this
              identifies the level of security used in
              obtaining the customer's payment credential. For
              mail or telephone order transactions, identifies
              the type of mail or telephone order.
            * `point_of_service_entry_mode` - The method used to enter the cardholder's primary
              account number and card expiration date.
            * `stand_in_processing_reason` - Only present when `actioner: network`. Describes
              why a card authorization was approved or declined
              by Visa through stand-in processing.
            * `terminal_entry_capability` - The capability of the terminal being used to read
              the card. Shows whether a terminal can e.g., accept
              chip cards or if it only supports magnetic stripe
              reads. This reflects the highest capability of the
              terminal — for example, a terminal that supports
              both chip and magnetic stripe will be identified as
              chip-capable.
          """

          defstruct [
            :electronic_commerce_indicator,
            :point_of_service_entry_mode,
            :stand_in_processing_reason,
            :terminal_entry_capability
          ]

          @type t :: %__MODULE__{
                  electronic_commerce_indicator: String.t() | nil,
                  point_of_service_entry_mode: String.t() | nil,
                  stand_in_processing_reason: String.t() | nil,
                  terminal_entry_capability: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              electronic_commerce_indicator: raw["electronic_commerce_indicator"],
              point_of_service_entry_mode: raw["point_of_service_entry_mode"],
              stand_in_processing_reason: raw["stand_in_processing_reason"],
              terminal_entry_capability: raw["terminal_entry_capability"]
            }
          end
        end

        defstruct [:category, :pulse, :visa]

        @type t :: %__MODULE__{
                category: String.t(),
                pulse: Pulse.t() | nil,
                visa: Visa.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            category: raw["category"],
            pulse: Increase.Decode.struct(raw["pulse"], &Pulse.decode/1),
            visa: Increase.Decode.struct(raw["visa"], &Visa.decode/1)
          }
        end
      end

      defmodule NetworkIdentifiers do
        @moduledoc """
        Network-specific identifiers for a specific request or transaction.

        ## Fields

          * `authorization_identification_response` - The randomly generated 6-character
            Authorization Identification Response code
            sent back to the acquirer in an approved
            response.
          * `retrieval_reference_number` - A life-cycle identifier used across e.g., an
            authorization and a reversal. Expected to be unique
            per acquirer within a window of time. For some card
            networks the retrieval reference number includes the
            trace counter.
          * `trace_number` - A counter used to verify an individual authorization. Expected to
            be unique per acquirer within a window of time.
          * `transaction_id` - A globally unique transaction identifier provided by the card
            network, used across multiple life-cycle requests.
        """

        defstruct [
          :authorization_identification_response,
          :retrieval_reference_number,
          :trace_number,
          :transaction_id
        ]

        @type t :: %__MODULE__{
                authorization_identification_response: String.t() | nil,
                retrieval_reference_number: String.t() | nil,
                trace_number: String.t() | nil,
                transaction_id: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            authorization_identification_response: raw["authorization_identification_response"],
            retrieval_reference_number: raw["retrieval_reference_number"],
            trace_number: raw["trace_number"],
            transaction_id: raw["transaction_id"]
          }
        end
      end

      defmodule Verification do
        @moduledoc """
        Fields related to verification of cardholder-provided values.

        ## Fields

          * `card_verification_code` - Fields related to verification of the Card Verification
            Code, a 3-digit code on the back of the card.
          * `cardholder_address` - Cardholder address provided in the authorization request and
            the address on file we verified it against.
          * `cardholder_name` - Cardholder name provided in the authorization request.
        """

        defmodule CardVerificationCode do
          @moduledoc """
          Fields related to verification of the Card Verification Code, a 3-digit code
          on the back of the card.

          ## Fields

            * `result` - The result of verifying the Card Verification Code.
          """

          defstruct [:result]

          @type t :: %__MODULE__{
                  result: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              result: raw["result"]
            }
          end
        end

        defmodule CardholderAddress do
          @moduledoc """
          Cardholder address provided in the authorization request and the address on
          file we verified it against.

          ## Fields

            * `actual_line1` - Line 1 of the address on file for the cardholder.
            * `actual_postal_code` - The postal code of the address on file for the cardholder.
            * `provided_line1` - The cardholder address line 1 provided for verification in the
              authorization request.
            * `provided_postal_code` - The postal code provided for verification in the
              authorization request.
            * `result` - The address verification result returned to the card network.
          """

          defstruct [
            :actual_line1,
            :actual_postal_code,
            :provided_line1,
            :provided_postal_code,
            :result
          ]

          @type t :: %__MODULE__{
                  actual_line1: String.t() | nil,
                  actual_postal_code: String.t() | nil,
                  provided_line1: String.t() | nil,
                  provided_postal_code: String.t() | nil,
                  result: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              actual_line1: raw["actual_line1"],
              actual_postal_code: raw["actual_postal_code"],
              provided_line1: raw["provided_line1"],
              provided_postal_code: raw["provided_postal_code"],
              result: raw["result"]
            }
          end
        end

        defmodule CardholderName do
          @moduledoc """
          Cardholder name provided in the authorization request.

          ## Fields

            * `provided_first_name` - The first name provided for verification in the
              authorization request.
            * `provided_last_name` - The last name provided for verification in the
              authorization request.
            * `provided_middle_name` - The middle name provided for verification in the
              authorization request.
          """

          defstruct [:provided_first_name, :provided_last_name, :provided_middle_name]

          @type t :: %__MODULE__{
                  provided_first_name: String.t() | nil,
                  provided_last_name: String.t() | nil,
                  provided_middle_name: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              provided_first_name: raw["provided_first_name"],
              provided_last_name: raw["provided_last_name"],
              provided_middle_name: raw["provided_middle_name"]
            }
          end
        end

        defstruct [:card_verification_code, :cardholder_address, :cardholder_name]

        @type t :: %__MODULE__{
                card_verification_code: CardVerificationCode.t(),
                cardholder_address: CardholderAddress.t(),
                cardholder_name: CardholderName.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            card_verification_code:
              Increase.Decode.struct(
                raw["card_verification_code"],
                &CardVerificationCode.decode/1
              ),
            cardholder_address:
              Increase.Decode.struct(raw["cardholder_address"], &CardholderAddress.decode/1),
            cardholder_name:
              Increase.Decode.struct(raw["cardholder_name"], &CardholderName.decode/1)
          }
        end
      end

      defstruct [
        :account_id,
        :additional_amounts,
        :approval,
        :card_id,
        :decision,
        :digital_wallet_token_id,
        :merchant_acceptor_id,
        :merchant_category_code,
        :merchant_city,
        :merchant_country,
        :merchant_descriptor,
        :merchant_postal_code,
        :merchant_state,
        :network_details,
        :network_identifiers,
        :network_risk_score,
        :physical_card_id,
        :terminal_id,
        :upcoming_card_payment_id,
        :verification
      ]

      @type t :: %__MODULE__{
              account_id: String.t(),
              additional_amounts: AdditionalAmounts.t(),
              approval: Approval.t() | nil,
              card_id: String.t(),
              decision: String.t() | nil,
              digital_wallet_token_id: String.t() | nil,
              merchant_acceptor_id: String.t(),
              merchant_category_code: String.t(),
              merchant_city: String.t() | nil,
              merchant_country: String.t(),
              merchant_descriptor: String.t(),
              merchant_postal_code: String.t() | nil,
              merchant_state: String.t() | nil,
              network_details: NetworkDetails.t(),
              network_identifiers: NetworkIdentifiers.t(),
              network_risk_score: integer() | nil,
              physical_card_id: String.t() | nil,
              terminal_id: String.t() | nil,
              upcoming_card_payment_id: String.t(),
              verification: Verification.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          additional_amounts:
            Increase.Decode.struct(raw["additional_amounts"], &AdditionalAmounts.decode/1),
          approval: Increase.Decode.struct(raw["approval"], &Approval.decode/1),
          card_id: raw["card_id"],
          decision: raw["decision"],
          digital_wallet_token_id: raw["digital_wallet_token_id"],
          merchant_acceptor_id: raw["merchant_acceptor_id"],
          merchant_category_code: raw["merchant_category_code"],
          merchant_city: raw["merchant_city"],
          merchant_country: raw["merchant_country"],
          merchant_descriptor: raw["merchant_descriptor"],
          merchant_postal_code: raw["merchant_postal_code"],
          merchant_state: raw["merchant_state"],
          network_details:
            Increase.Decode.struct(raw["network_details"], &NetworkDetails.decode/1),
          network_identifiers:
            Increase.Decode.struct(raw["network_identifiers"], &NetworkIdentifiers.decode/1),
          network_risk_score: raw["network_risk_score"],
          physical_card_id: raw["physical_card_id"],
          terminal_id: raw["terminal_id"],
          upcoming_card_payment_id: raw["upcoming_card_payment_id"],
          verification: Increase.Decode.struct(raw["verification"], &Verification.decode/1)
        }
      end
    end

    defmodule DigitalWalletAuthentication do
      @moduledoc """
      Fields related to a digital wallet authentication attempt.

      ## Fields

        * `card_id` - The identifier of the Card that is being tokenized.
        * `channel` - The channel to send the card user their one-time passcode.
        * `digital_wallet` - The digital wallet app being used.
        * `email` - The email to send the one-time passcode to if `channel` is equal to `email`.
        * `one_time_passcode` - The one-time passcode to send the card user.
        * `phone` - The phone number to send the one-time passcode to if `channel` is equal to
          `sms`.
        * `result` - Whether your application successfully delivered the one-time passcode.
      """

      defstruct [:card_id, :channel, :digital_wallet, :email, :one_time_passcode, :phone, :result]

      @type t :: %__MODULE__{
              card_id: String.t(),
              channel: String.t(),
              digital_wallet: String.t(),
              email: String.t() | nil,
              one_time_passcode: String.t(),
              phone: String.t() | nil,
              result: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          card_id: raw["card_id"],
          channel: raw["channel"],
          digital_wallet: raw["digital_wallet"],
          email: raw["email"],
          one_time_passcode: raw["one_time_passcode"],
          phone: raw["phone"],
          result: raw["result"]
        }
      end
    end

    defmodule DigitalWalletToken do
      @moduledoc """
      Fields related to a digital wallet token provisioning attempt.

      ## Fields

        * `card_id` - The identifier of the Card that is being tokenized.
        * `decision` - Whether or not the provisioning request was approved. This will be null
          until the real time decision is responded to.
        * `device` - Device that is being used to provision the digital wallet token.
        * `digital_wallet` - The digital wallet app being used.
      """

      defmodule Device do
        @moduledoc """
        Device that is being used to provision the digital wallet token.

        ## Fields

          * `identifier` - ID assigned to the device by the digital wallet provider.
        """

        defstruct [:identifier]

        @type t :: %__MODULE__{
                identifier: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            identifier: raw["identifier"]
          }
        end
      end

      defstruct [:card_id, :decision, :device, :digital_wallet]

      @type t :: %__MODULE__{
              card_id: String.t(),
              decision: String.t() | nil,
              device: Device.t(),
              digital_wallet: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          card_id: raw["card_id"],
          decision: raw["decision"],
          device: Increase.Decode.struct(raw["device"], &Device.decode/1),
          digital_wallet: raw["digital_wallet"]
        }
      end
    end

    defstruct [
      :id,
      :card_authentication,
      :card_authentication_challenge,
      :card_authorization,
      :card_balance_inquiry,
      :category,
      :created_at,
      :digital_wallet_authentication,
      :digital_wallet_token,
      :status,
      :timeout_at,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            card_authentication: CardAuthentication.t() | nil,
            card_authentication_challenge: CardAuthenticationChallenge.t() | nil,
            card_authorization: CardAuthorization.t() | nil,
            card_balance_inquiry: CardBalanceInquiry.t() | nil,
            category: String.t(),
            created_at: DateTime.t(),
            digital_wallet_authentication: DigitalWalletAuthentication.t() | nil,
            digital_wallet_token: DigitalWalletToken.t() | nil,
            status: String.t(),
            timeout_at: DateTime.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        card_authentication:
          Increase.Decode.struct(raw["card_authentication"], &CardAuthentication.decode/1),
        card_authentication_challenge:
          Increase.Decode.struct(
            raw["card_authentication_challenge"],
            &CardAuthenticationChallenge.decode/1
          ),
        card_authorization:
          Increase.Decode.struct(raw["card_authorization"], &CardAuthorization.decode/1),
        card_balance_inquiry:
          Increase.Decode.struct(raw["card_balance_inquiry"], &CardBalanceInquiry.decode/1),
        category: raw["category"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        digital_wallet_authentication:
          Increase.Decode.struct(
            raw["digital_wallet_authentication"],
            &DigitalWalletAuthentication.decode/1
          ),
        digital_wallet_token:
          Increase.Decode.struct(raw["digital_wallet_token"], &DigitalWalletToken.decode/1),
        status: raw["status"],
        timeout_at: Increase.Decode.datetime(raw["timeout_at"]),
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve a Real-Time Decision

  `GET /real_time_decisions/{real_time_decision_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, RealTimeDecision.t()} | {:error, Increase.Error.t()}
  def retrieve(client, real_time_decision_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/real_time_decisions/#{real_time_decision_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, RealTimeDecision.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Action a Real-Time Decision

  `POST /real_time_decisions/{real_time_decision_id}/action`
  """
  @spec action(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, RealTimeDecision.t()} | {:error, Increase.Error.t()}
  def action(client, real_time_decision_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/real_time_decisions/#{real_time_decision_id}/action"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, RealTimeDecision.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
