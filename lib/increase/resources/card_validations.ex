defmodule Increase.CardValidations do
  @moduledoc """
  Card Validations are used to validate a card and its cardholder before sending
  funds to or pulling funds from a card.

  See https://increase.com/documentation/api/card-validations for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CardValidation do
    @moduledoc """
    Card Validations are used to validate a card and its cardholder before
    sending funds to or pulling funds from a card.

    ## Fields

      * `id` - The Card Validation's identifier.
      * `acceptance` - If the validation is accepted by the recipient bank, this will contain
        supplemental details.
      * `account_id` - The identifier of the Account from which to send the validation.
      * `card_token_id` - The ID of the Card Token that was used to validate the card.
      * `cardholder_first_name` - The cardholder's first name.
      * `cardholder_last_name` - The cardholder's last name.
      * `cardholder_middle_name` - The cardholder's middle name.
      * `cardholder_postal_code` - The postal code of the cardholder's address.
      * `cardholder_street_address` - The cardholder's street address.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the validation was created.
      * `created_by` - What object created the validation, either via the API or the dashboard.
      * `decline` - If the validation is rejected by the card network or the destination
        financial institution, this will contain supplemental details.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `merchant_category_code` - A four-digit code (MCC) identifying the type of business or
        service provided by the merchant.
      * `merchant_city_name` - The city where the merchant (typically your business) is located.
      * `merchant_name` - The merchant name that will appear in the cardholder’s statement
        descriptor. Typically your business name.
      * `merchant_postal_code` - The postal code for the merchant’s (typically your business’s)
        location.
      * `merchant_state` - The U.S. state where the merchant (typically your business) is
        located.
      * `route` - The card network route used for the validation.
      * `status` - The lifecycle status of the validation.
      * `submission` - After the validation is submitted to the card network, this will contain
        supplemental details.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_validation`.
    """

    defmodule Acceptance do
      @moduledoc """
      If the validation is accepted by the recipient bank, this will contain
      supplemental details.

      ## Fields

        * `accepted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the validation was accepted by the issuing bank.
        * `authorization_identification_response` - The authorization identification response
          from the issuing bank.
        * `card_verification_value2_result` - The result of the Card Verification Value 2 match.
        * `cardholder_first_name_result` - The result of the cardholder first name match.
        * `cardholder_full_name_result` - The result of the cardholder full name match.
        * `cardholder_last_name_result` - The result of the cardholder last name match.
        * `cardholder_middle_name_result` - The result of the cardholder middle name match.
        * `cardholder_postal_code_result` - The result of the cardholder postal code match.
        * `cardholder_street_address_result` - The result of the cardholder street address
          match.
        * `network_transaction_identifier` - A unique identifier for the transaction on the card
          network.
      """

      defstruct [
        :accepted_at,
        :authorization_identification_response,
        :card_verification_value2_result,
        :cardholder_first_name_result,
        :cardholder_full_name_result,
        :cardholder_last_name_result,
        :cardholder_middle_name_result,
        :cardholder_postal_code_result,
        :cardholder_street_address_result,
        :network_transaction_identifier
      ]

      @type t :: %__MODULE__{
              accepted_at: DateTime.t(),
              authorization_identification_response: String.t(),
              card_verification_value2_result: String.t() | nil,
              cardholder_first_name_result: String.t() | nil,
              cardholder_full_name_result: String.t() | nil,
              cardholder_last_name_result: String.t() | nil,
              cardholder_middle_name_result: String.t() | nil,
              cardholder_postal_code_result: String.t() | nil,
              cardholder_street_address_result: String.t() | nil,
              network_transaction_identifier: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          accepted_at: Increase.Decode.datetime(raw["accepted_at"]),
          authorization_identification_response: raw["authorization_identification_response"],
          card_verification_value2_result: raw["card_verification_value2_result"],
          cardholder_first_name_result: raw["cardholder_first_name_result"],
          cardholder_full_name_result: raw["cardholder_full_name_result"],
          cardholder_last_name_result: raw["cardholder_last_name_result"],
          cardholder_middle_name_result: raw["cardholder_middle_name_result"],
          cardholder_postal_code_result: raw["cardholder_postal_code_result"],
          cardholder_street_address_result: raw["cardholder_street_address_result"],
          network_transaction_identifier: raw["network_transaction_identifier"]
        }
      end
    end

    defmodule CreatedBy do
      @moduledoc """
      What object created the validation, either via the API or the dashboard.

      ## Fields

        * `category` - The type of object that created this transfer.
        * `api_key` - If present, details about the API key that created the transfer.
        * `oauth_application` - If present, details about the OAuth Application that created the
          transfer.
        * `user` - If present, details about the User that created the transfer.
      """

      defmodule APIKey do
        @moduledoc """
        If present, details about the API key that created the transfer.

        ## Fields

          * `description` - The description set for the API key when it was created.
        """

        defstruct [:description]

        @type t :: %__MODULE__{
                description: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            description: raw["description"]
          }
        end
      end

      defmodule OAuthApplication do
        @moduledoc """
        If present, details about the OAuth Application that created the transfer.

        ## Fields

          * `name` - The name of the OAuth Application.
        """

        defstruct [:name]

        @type t :: %__MODULE__{
                name: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            name: raw["name"]
          }
        end
      end

      defmodule User do
        @moduledoc """
        If present, details about the User that created the transfer.

        ## Fields

          * `email` - The email address of the User.
        """

        defstruct [:email]

        @type t :: %__MODULE__{
                email: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            email: raw["email"]
          }
        end
      end

      defstruct [:category, :api_key, :oauth_application, :user]

      @type t :: %__MODULE__{
              category: String.t(),
              api_key: APIKey.t() | nil,
              oauth_application: OAuthApplication.t() | nil,
              user: User.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          category: raw["category"],
          api_key: Increase.Decode.struct(raw["api_key"], &APIKey.decode/1),
          oauth_application:
            Increase.Decode.struct(raw["oauth_application"], &OAuthApplication.decode/1),
          user: Increase.Decode.struct(raw["user"], &User.decode/1)
        }
      end
    end

    defmodule Decline do
      @moduledoc """
      If the validation is rejected by the card network or the destination
      financial institution, this will contain supplemental details.

      ## Fields

        * `declined_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the validation was declined.
        * `network_transaction_identifier` - A unique identifier for the transaction on the card
          network.
        * `reason` - The reason why the validation was declined.
      """

      defstruct [:declined_at, :network_transaction_identifier, :reason]

      @type t :: %__MODULE__{
              declined_at: DateTime.t(),
              network_transaction_identifier: String.t() | nil,
              reason: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          declined_at: Increase.Decode.datetime(raw["declined_at"]),
          network_transaction_identifier: raw["network_transaction_identifier"],
          reason: raw["reason"]
        }
      end
    end

    defmodule Submission do
      @moduledoc """
      After the validation is submitted to the card network, this will contain
      supplemental details.

      ## Fields

        * `retrieval_reference_number` - A 12-digit retrieval reference number that identifies
          the validation. Usually a combination of a timestamp
          and the trace number.
        * `submitted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the validation was submitted to the card network.
        * `trace_number` - A 6-digit trace number that identifies the validation within a short
          time window.
      """

      defstruct [:retrieval_reference_number, :submitted_at, :trace_number]

      @type t :: %__MODULE__{
              retrieval_reference_number: String.t(),
              submitted_at: DateTime.t(),
              trace_number: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          retrieval_reference_number: raw["retrieval_reference_number"],
          submitted_at: Increase.Decode.datetime(raw["submitted_at"]),
          trace_number: raw["trace_number"]
        }
      end
    end

    defstruct [
      :id,
      :acceptance,
      :account_id,
      :card_token_id,
      :cardholder_first_name,
      :cardholder_last_name,
      :cardholder_middle_name,
      :cardholder_postal_code,
      :cardholder_street_address,
      :created_at,
      :created_by,
      :decline,
      :idempotency_key,
      :merchant_category_code,
      :merchant_city_name,
      :merchant_name,
      :merchant_postal_code,
      :merchant_state,
      :route,
      :status,
      :submission,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            acceptance: Acceptance.t() | nil,
            account_id: String.t(),
            card_token_id: String.t(),
            cardholder_first_name: String.t() | nil,
            cardholder_last_name: String.t() | nil,
            cardholder_middle_name: String.t() | nil,
            cardholder_postal_code: String.t() | nil,
            cardholder_street_address: String.t() | nil,
            created_at: DateTime.t(),
            created_by: CreatedBy.t() | nil,
            decline: Decline.t() | nil,
            idempotency_key: String.t() | nil,
            merchant_category_code: String.t(),
            merchant_city_name: String.t(),
            merchant_name: String.t(),
            merchant_postal_code: String.t(),
            merchant_state: String.t(),
            route: String.t(),
            status: String.t(),
            submission: Submission.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        acceptance: Increase.Decode.struct(raw["acceptance"], &Acceptance.decode/1),
        account_id: raw["account_id"],
        card_token_id: raw["card_token_id"],
        cardholder_first_name: raw["cardholder_first_name"],
        cardholder_last_name: raw["cardholder_last_name"],
        cardholder_middle_name: raw["cardholder_middle_name"],
        cardholder_postal_code: raw["cardholder_postal_code"],
        cardholder_street_address: raw["cardholder_street_address"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        decline: Increase.Decode.struct(raw["decline"], &Decline.decode/1),
        idempotency_key: raw["idempotency_key"],
        merchant_category_code: raw["merchant_category_code"],
        merchant_city_name: raw["merchant_city_name"],
        merchant_name: raw["merchant_name"],
        merchant_postal_code: raw["merchant_postal_code"],
        merchant_state: raw["merchant_state"],
        route: raw["route"],
        status: raw["status"],
        submission: Increase.Decode.struct(raw["submission"], &Submission.decode/1),
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Card Validation

  `POST /card_validations`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, CardValidation.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_validations"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CardValidation.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Card Validation

  `GET /card_validations/{card_validation_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardValidation.t()} | {:error, Increase.Error.t()}
  def retrieve(client, card_validation_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_validations/#{card_validation_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardValidation.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Card Validations

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CardValidation{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /card_validations`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_validations"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CardValidation.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
