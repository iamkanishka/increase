defmodule Increase.CardPushTransfers do
  @moduledoc """
  Card Push Transfers send funds to a recipient's payment card in real-time.

  See https://increase.com/documentation/api/card-push-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CardPushTransfer do
    @moduledoc """
    Card Push Transfers send funds to a recipient's payment card in real-time.

    ## Fields

      * `id` - The Card Push Transfer's identifier.
      * `acceptance` - If the transfer is accepted by the recipient bank, this will contain
        supplemental details.
      * `account_id` - The Account from which the transfer was sent.
      * `approval` - If your account requires approvals for transfers and the transfer was
        approved, this will contain details of the approval.
      * `business_application_identifier` - The Business Application Identifier describes the
        type of transaction being performed. Your program
        must be approved for the specified Business
        Application Identifier in order to use it.
      * `cancellation` - If your account requires approvals for transfers and the transfer was
        not approved, this will contain details of the cancellation.
      * `card_token_id` - The ID of the Card Token that was used to validate the card.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `created_by` - What object created the transfer, either via the API or the dashboard.
      * `decline` - If the transfer is rejected by the card network or the destination financial
        institution, this will contain supplemental details.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `merchant_category_code` - The merchant category code (MCC) of the merchant (generally
        your business) sending the transfer. This is a four-digit
        code that describes the type of business or service provided
        by the merchant. Your program must be approved for the
        specified MCC in order to use it.
      * `merchant_city_name` - The city name of the merchant (generally your business) sending
        the transfer.
      * `merchant_legal_business_name` - The legal business name of the merchant (generally your
        business) sending the transfer.
      * `merchant_name` - The merchant name shows up as the statement descriptor for the
        transfer. This is typically the name of your business or organization.
      * `merchant_name_prefix` - For certain Business Application Identifiers, the statement
        descriptor is `merchant_name_prefix*sender_name`, where the
        `merchant_name_prefix` is a one to four character prefix that
        identifies the merchant.
      * `merchant_postal_code` - The postal code of the merchant (generally your business)
        sending the transfer.
      * `merchant_state` - The state of the merchant (generally your business) sending the
        transfer.
      * `merchant_street_address` - The street address of the merchant (generally your business)
        sending the transfer.
      * `presentment_amount` - The amount that was transferred. The receiving bank will have
        converted this to the cardholder's currency. The amount that is
        applied to your Increase account matches the currency of your
        account.
      * `recipient_address_city` - The city of the recipient. Required if the card is issued in
        Canada.
      * `recipient_address_line1` - The first line of the recipient's address. Required if the
        card is issued in Canada.
      * `recipient_address_postal_code` - The postal code of the recipient. Required if the card
        is issued in Canada.
      * `recipient_address_state` - The state or province of the recipient. Required if the card
        is issued in Canada.
      * `recipient_name` - The name of the funds recipient.
      * `route` - The card network route used for the transfer.
      * `sender_address_city` - The city of the sender.
      * `sender_address_line1` - The address line 1 of the sender.
      * `sender_address_postal_code` - The postal code of the sender.
      * `sender_address_state` - The state of the sender.
      * `sender_name` - The name of the funds originator.
      * `source_account_number_id` - The Account Number the recipient will see as having sent
        the transfer.
      * `status` - The lifecycle status of the transfer.
      * `submission` - After the transfer is submitted to the card network, this will contain
        supplemental details.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_push_transfer`.
    """

    defmodule Acceptance do
      @moduledoc """
      If the transfer is accepted by the recipient bank, this will contain
      supplemental details.

      ## Fields

        * `accepted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was accepted by the issuing bank.
        * `authorization_identification_response` - The authorization identification response
          from the issuing bank.
        * `card_verification_value2_result` - The result of the Card Verification Value 2 match.
        * `network_transaction_identifier` - A unique identifier for the transaction on the card
          network.
        * `settlement_amount` - The transfer amount in USD cents.
      """

      defstruct [
        :accepted_at,
        :authorization_identification_response,
        :card_verification_value2_result,
        :network_transaction_identifier,
        :settlement_amount
      ]

      @type t :: %__MODULE__{
              accepted_at: DateTime.t(),
              authorization_identification_response: String.t(),
              card_verification_value2_result: String.t() | nil,
              network_transaction_identifier: String.t() | nil,
              settlement_amount: integer()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          accepted_at: Increase.Decode.datetime(raw["accepted_at"]),
          authorization_identification_response: raw["authorization_identification_response"],
          card_verification_value2_result: raw["card_verification_value2_result"],
          network_transaction_identifier: raw["network_transaction_identifier"],
          settlement_amount: raw["settlement_amount"]
        }
      end
    end

    defmodule Approval do
      @moduledoc """
      If your account requires approvals for transfers and the transfer was
      approved, this will contain details of the approval.

      ## Fields

        * `approved_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was approved.
        * `approved_by` - If the Transfer was approved by a user in the dashboard, the email
          address of that user.
      """

      defstruct [:approved_at, :approved_by]

      @type t :: %__MODULE__{
              approved_at: DateTime.t(),
              approved_by: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          approved_at: Increase.Decode.datetime(raw["approved_at"]),
          approved_by: raw["approved_by"]
        }
      end
    end

    defmodule Cancellation do
      @moduledoc """
      If your account requires approvals for transfers and the transfer was not
      approved, this will contain details of the cancellation.

      ## Fields

        * `canceled_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the Transfer was canceled.
        * `canceled_by` - If the Transfer was canceled by a user in the dashboard, the email
          address of that user.
      """

      defstruct [:canceled_at, :canceled_by]

      @type t :: %__MODULE__{
              canceled_at: DateTime.t(),
              canceled_by: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          canceled_at: Increase.Decode.datetime(raw["canceled_at"]),
          canceled_by: raw["canceled_by"]
        }
      end
    end

    defmodule CreatedBy do
      @moduledoc """
      What object created the transfer, either via the API or the dashboard.

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
      If the transfer is rejected by the card network or the destination financial
      institution, this will contain supplemental details.

      ## Fields

        * `declined_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer declined.
        * `network_transaction_identifier` - A unique identifier for the transaction on the card
          network.
        * `reason` - The reason why the transfer was declined.
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

    defmodule PresentmentAmount do
      @moduledoc """
      The amount that was transferred. The receiving bank will have converted this
      to the cardholder's currency. The amount that is applied to your Increase
      account matches the currency of your account.

      ## Fields

        * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) currency code.
        * `value` - The amount value represented as a string containing a decimal number in
          major units (so e.g., "12.34" for $12.34).
      """

      defstruct [:currency, :value]

      @type t :: %__MODULE__{
              currency: String.t(),
              value: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          currency: raw["currency"],
          value: raw["value"]
        }
      end
    end

    defmodule Submission do
      @moduledoc """
      After the transfer is submitted to the card network, this will contain
      supplemental details.

      ## Fields

        * `retrieval_reference_number` - A 12-digit retrieval reference number that identifies
          the transfer. Usually a combination of a timestamp and
          the trace number.
        * `sender_reference` - A unique reference for the transfer.
        * `submitted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was submitted to the card network.
        * `trace_number` - A 6-digit trace number that identifies the transfer within a small
          window of time.
      """

      defstruct [:retrieval_reference_number, :sender_reference, :submitted_at, :trace_number]

      @type t :: %__MODULE__{
              retrieval_reference_number: String.t(),
              sender_reference: String.t(),
              submitted_at: DateTime.t(),
              trace_number: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          retrieval_reference_number: raw["retrieval_reference_number"],
          sender_reference: raw["sender_reference"],
          submitted_at: Increase.Decode.datetime(raw["submitted_at"]),
          trace_number: raw["trace_number"]
        }
      end
    end

    defstruct [
      :id,
      :acceptance,
      :account_id,
      :approval,
      :business_application_identifier,
      :cancellation,
      :card_token_id,
      :created_at,
      :created_by,
      :decline,
      :idempotency_key,
      :merchant_category_code,
      :merchant_city_name,
      :merchant_legal_business_name,
      :merchant_name,
      :merchant_name_prefix,
      :merchant_postal_code,
      :merchant_state,
      :merchant_street_address,
      :presentment_amount,
      :recipient_address_city,
      :recipient_address_line1,
      :recipient_address_postal_code,
      :recipient_address_state,
      :recipient_name,
      :route,
      :sender_address_city,
      :sender_address_line1,
      :sender_address_postal_code,
      :sender_address_state,
      :sender_name,
      :source_account_number_id,
      :status,
      :submission,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            acceptance: Acceptance.t() | nil,
            account_id: String.t(),
            approval: Approval.t() | nil,
            business_application_identifier: String.t(),
            cancellation: Cancellation.t() | nil,
            card_token_id: String.t(),
            created_at: DateTime.t(),
            created_by: CreatedBy.t() | nil,
            decline: Decline.t() | nil,
            idempotency_key: String.t() | nil,
            merchant_category_code: String.t(),
            merchant_city_name: String.t(),
            merchant_legal_business_name: String.t() | nil,
            merchant_name: String.t(),
            merchant_name_prefix: String.t(),
            merchant_postal_code: String.t(),
            merchant_state: String.t(),
            merchant_street_address: String.t() | nil,
            presentment_amount: PresentmentAmount.t(),
            recipient_address_city: String.t() | nil,
            recipient_address_line1: String.t() | nil,
            recipient_address_postal_code: String.t() | nil,
            recipient_address_state: String.t() | nil,
            recipient_name: String.t(),
            route: String.t(),
            sender_address_city: String.t(),
            sender_address_line1: String.t(),
            sender_address_postal_code: String.t(),
            sender_address_state: String.t(),
            sender_name: String.t(),
            source_account_number_id: String.t(),
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
        approval: Increase.Decode.struct(raw["approval"], &Approval.decode/1),
        business_application_identifier: raw["business_application_identifier"],
        cancellation: Increase.Decode.struct(raw["cancellation"], &Cancellation.decode/1),
        card_token_id: raw["card_token_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        decline: Increase.Decode.struct(raw["decline"], &Decline.decode/1),
        idempotency_key: raw["idempotency_key"],
        merchant_category_code: raw["merchant_category_code"],
        merchant_city_name: raw["merchant_city_name"],
        merchant_legal_business_name: raw["merchant_legal_business_name"],
        merchant_name: raw["merchant_name"],
        merchant_name_prefix: raw["merchant_name_prefix"],
        merchant_postal_code: raw["merchant_postal_code"],
        merchant_state: raw["merchant_state"],
        merchant_street_address: raw["merchant_street_address"],
        presentment_amount:
          Increase.Decode.struct(raw["presentment_amount"], &PresentmentAmount.decode/1),
        recipient_address_city: raw["recipient_address_city"],
        recipient_address_line1: raw["recipient_address_line1"],
        recipient_address_postal_code: raw["recipient_address_postal_code"],
        recipient_address_state: raw["recipient_address_state"],
        recipient_name: raw["recipient_name"],
        route: raw["route"],
        sender_address_city: raw["sender_address_city"],
        sender_address_line1: raw["sender_address_line1"],
        sender_address_postal_code: raw["sender_address_postal_code"],
        sender_address_state: raw["sender_address_state"],
        sender_name: raw["sender_name"],
        source_account_number_id: raw["source_account_number_id"],
        status: raw["status"],
        submission: Increase.Decode.struct(raw["submission"], &Submission.decode/1),
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Card Push Transfer

  `POST /card_push_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, CardPushTransfer.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_push_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CardPushTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Card Push Transfer

  `GET /card_push_transfers/{card_push_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardPushTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, card_push_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_push_transfers/#{card_push_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardPushTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Card Push Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CardPushTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /card_push_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_push_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CardPushTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Approves a Card Push Transfer in a pending_approval state.

  `POST /card_push_transfers/{card_push_transfer_id}/approve`
  """
  @spec approve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardPushTransfer.t()} | {:error, Increase.Error.t()}
  def approve(client, card_push_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_push_transfers/#{card_push_transfer_id}/approve"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardPushTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Cancels a Card Push Transfer in a pending_approval state.

  `POST /card_push_transfers/{card_push_transfer_id}/cancel`
  """
  @spec cancel(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardPushTransfer.t()} | {:error, Increase.Error.t()}
  def cancel(client, card_push_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_push_transfers/#{card_push_transfer_id}/cancel"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardPushTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
