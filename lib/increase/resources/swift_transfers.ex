defmodule Increase.SwiftTransfers do
  @moduledoc """
  Swift Transfers send funds internationally.

  See https://increase.com/documentation/api/swift-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule SwiftTransfer do
    @moduledoc """
    Swift Transfers send funds internationally.

    ## Fields

      * `id` - The Swift transfer's identifier.
      * `account_id` - The Account to which the transfer belongs.
      * `account_number` - The creditor's account number.
      * `amount` - The transfer amount in USD cents.
      * `bank_identification_code` - The bank identification code (BIC) of the creditor.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `created_by` - What object created the transfer, either via the API or the dashboard.
      * `creditor_address` - The creditor's address.
      * `creditor_name` - The creditor's name.
      * `debtor_address` - The debtor's address.
      * `debtor_name` - The debtor's name.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `instructed_amount` - The amount that was instructed to be transferred in minor units of
        the `instructed_currency`.
      * `instructed_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) currency
        code of the instructed amount.
      * `pending_transaction_id` - The ID for the pending transaction representing the transfer.
      * `routing_number` - The creditor's bank account routing or transit number. Required in
        certain countries.
      * `source_account_number_id` - The Account Number included in the transfer as the debtor's
        account number.
      * `status` - The lifecycle status of the transfer.
      * `transaction_id` - The ID for the transaction funding the transfer. This will be
        populated after the transfer is initiated.
      * `type` - A constant representing the object's type. For this resource it will always be
        `swift_transfer`.
      * `unique_end_to_end_transaction_reference` - The Unique End-to-end Transaction Reference
        ([UETR](https://www.swift.com/payments/what-unique-end-end-transaction-reference-uetr))
        for the transfer.
      * `unstructured_remittance_information` - The unstructured remittance information that was
        included with the transfer.
    """

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

    defmodule CreditorAddress do
      @moduledoc """
      The creditor's address.

      ## Fields

        * `city` - The city, district, town, or village of the address.
        * `country` - The two-letter [ISO 3166-1
          alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code for the
          country of the address.
        * `line1` - The first line of the address.
        * `line2` - The second line of the address.
        * `postal_code` - The ZIP or postal code of the address.
        * `state` - The state, province, or region of the address. Required in certain
          countries.
      """

      defstruct [:city, :country, :line1, :line2, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t() | nil,
              country: String.t(),
              line1: String.t(),
              line2: String.t() | nil,
              postal_code: String.t() | nil,
              state: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          country: raw["country"],
          line1: raw["line1"],
          line2: raw["line2"],
          postal_code: raw["postal_code"],
          state: raw["state"]
        }
      end
    end

    defmodule DebtorAddress do
      @moduledoc """
      The debtor's address.

      ## Fields

        * `city` - The city, district, town, or village of the address.
        * `country` - The two-letter [ISO 3166-1
          alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code for the
          country of the address.
        * `line1` - The first line of the address.
        * `line2` - The second line of the address.
        * `postal_code` - The ZIP or postal code of the address.
        * `state` - The state, province, or region of the address. Required in certain
          countries.
      """

      defstruct [:city, :country, :line1, :line2, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t() | nil,
              country: String.t(),
              line1: String.t(),
              line2: String.t() | nil,
              postal_code: String.t() | nil,
              state: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          country: raw["country"],
          line1: raw["line1"],
          line2: raw["line2"],
          postal_code: raw["postal_code"],
          state: raw["state"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number,
      :amount,
      :bank_identification_code,
      :created_at,
      :created_by,
      :creditor_address,
      :creditor_name,
      :debtor_address,
      :debtor_name,
      :idempotency_key,
      :instructed_amount,
      :instructed_currency,
      :pending_transaction_id,
      :routing_number,
      :source_account_number_id,
      :status,
      :transaction_id,
      :type,
      :unique_end_to_end_transaction_reference,
      :unstructured_remittance_information
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            account_number: String.t(),
            amount: integer(),
            bank_identification_code: String.t(),
            created_at: DateTime.t(),
            created_by: CreatedBy.t(),
            creditor_address: CreditorAddress.t(),
            creditor_name: String.t(),
            debtor_address: DebtorAddress.t(),
            debtor_name: String.t(),
            idempotency_key: String.t() | nil,
            instructed_amount: integer(),
            instructed_currency: String.t(),
            pending_transaction_id: String.t() | nil,
            routing_number: String.t() | nil,
            source_account_number_id: String.t(),
            status: String.t(),
            transaction_id: String.t() | nil,
            type: String.t(),
            unique_end_to_end_transaction_reference: String.t(),
            unstructured_remittance_information: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        account_number: raw["account_number"],
        amount: raw["amount"],
        bank_identification_code: raw["bank_identification_code"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        creditor_address:
          Increase.Decode.struct(raw["creditor_address"], &CreditorAddress.decode/1),
        creditor_name: raw["creditor_name"],
        debtor_address: Increase.Decode.struct(raw["debtor_address"], &DebtorAddress.decode/1),
        debtor_name: raw["debtor_name"],
        idempotency_key: raw["idempotency_key"],
        instructed_amount: raw["instructed_amount"],
        instructed_currency: raw["instructed_currency"],
        pending_transaction_id: raw["pending_transaction_id"],
        routing_number: raw["routing_number"],
        source_account_number_id: raw["source_account_number_id"],
        status: raw["status"],
        transaction_id: raw["transaction_id"],
        type: raw["type"],
        unique_end_to_end_transaction_reference: raw["unique_end_to_end_transaction_reference"],
        unstructured_remittance_information: raw["unstructured_remittance_information"]
      }
    end
  end

  @doc """
  Create a Swift Transfer

  `POST /swift_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, SwiftTransfer.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/swift_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, SwiftTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Swift Transfer

  `GET /swift_transfers/{swift_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, SwiftTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, swift_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/swift_transfers/#{swift_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, SwiftTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Swift Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  SwiftTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /swift_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/swift_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &SwiftTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Approve a Swift Transfer

  `POST /swift_transfers/{swift_transfer_id}/approve`
  """
  @spec approve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, SwiftTransfer.t()} | {:error, Increase.Error.t()}
  def approve(client, swift_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/swift_transfers/#{swift_transfer_id}/approve"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, SwiftTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Cancel a pending Swift Transfer

  `POST /swift_transfers/{swift_transfer_id}/cancel`
  """
  @spec cancel(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, SwiftTransfer.t()} | {:error, Increase.Error.t()}
  def cancel(client, swift_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/swift_transfers/#{swift_transfer_id}/cancel"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, SwiftTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
