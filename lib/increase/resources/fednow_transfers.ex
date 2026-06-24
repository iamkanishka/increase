defmodule Increase.FednowTransfers do
  @moduledoc """
  FedNow transfers move funds, within seconds, between your Increase account and
  any other account supporting FedNow.

  See https://increase.com/documentation/api/fednow-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule FednowTransfer do
    @moduledoc """
    FedNow transfers move funds, within seconds, between your Increase account
    and any other account supporting FedNow.

    ## Fields

      * `id` - The FedNow Transfer's identifier.
      * `account_id` - The Account from which the transfer was sent.
      * `account_number` - The destination account number.
      * `acknowledgement` - If the transfer is acknowledged by the recipient bank, this will
        contain supplemental details.
      * `amount` - The transfer amount in USD cents.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `created_by` - What object created the transfer, either via the API or the dashboard.
      * `creditor_address` - The creditor's address.
      * `creditor_name` - The name of the transfer's recipient. This is set by the sender when
        creating the transfer.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
        transfer's currency. For FedNow transfers this is always equal to `USD`.
      * `debtor_address` - The debtor's address.
      * `debtor_name` - The name of the transfer's sender. If not provided, defaults to the name
        of the account's entity.
      * `external_account_id` - The identifier of the External Account the transfer was made to,
        if any.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `pending_transaction_id` - The ID for the pending transaction representing the transfer.
      * `rejection` - If the transfer is rejected by FedNow or the destination financial
        institution, this will contain supplemental details.
      * `routing_number` - The destination American Bankers' Association (ABA) Routing Transit
        Number (RTN).
      * `source_account_number_id` - The Account Number the recipient will see as having sent
        the transfer.
      * `status` - The lifecycle status of the transfer.
      * `submission` - After the transfer is submitted to FedNow, this will contain supplemental
        details.
      * `transaction_id` - The Transaction funding the transfer once it is complete.
      * `type` - A constant representing the object's type. For this resource it will always be
        `fednow_transfer`.
      * `unique_end_to_end_transaction_reference` - The Unique End-to-end Transaction Reference
        ([UETR](https://www.swift.com/payments/what-unique-end-end-transaction-reference-uetr))
        of the transfer.
      * `unstructured_remittance_information` - Unstructured information that will show on the
        recipient's bank statement.
    """

    defmodule Acknowledgement do
      @moduledoc """
      If the transfer is acknowledged by the recipient bank, this will contain
      supplemental details.

      ## Fields

        * `acknowledged_at` - When the transfer was acknowledged.
      """

      defstruct [:acknowledged_at]

      @type t :: %__MODULE__{
              acknowledged_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          acknowledged_at: Increase.Decode.datetime(raw["acknowledged_at"])
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

    defmodule CreditorAddress do
      @moduledoc """
      The creditor's address.

      ## Fields

        * `city` - The city, district, town, or village of the address.
        * `line1` - The first line of the address.
        * `postal_code` - The ZIP code of the address.
        * `state` - The address state.
      """

      defstruct [:city, :line1, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t() | nil,
              line1: String.t() | nil,
              postal_code: String.t() | nil,
              state: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          line1: raw["line1"],
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
        * `line1` - The first line of the address.
        * `postal_code` - The ZIP code of the address.
        * `state` - The address state.
      """

      defstruct [:city, :line1, :postal_code, :state]

      @type t :: %__MODULE__{
              city: String.t() | nil,
              line1: String.t() | nil,
              postal_code: String.t() | nil,
              state: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          city: raw["city"],
          line1: raw["line1"],
          postal_code: raw["postal_code"],
          state: raw["state"]
        }
      end
    end

    defmodule Rejection do
      @moduledoc """
      If the transfer is rejected by FedNow or the destination financial
      institution, this will contain supplemental details.

      ## Fields

        * `reject_reason_additional_information` - Additional information about the rejection
          provided by the recipient bank.
        * `reject_reason_code` - The reason the transfer was rejected as provided by the
          recipient bank or the FedNow network.
        * `rejected_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was rejected.
      """

      defstruct [:reject_reason_additional_information, :reject_reason_code, :rejected_at]

      @type t :: %__MODULE__{
              reject_reason_additional_information: String.t() | nil,
              reject_reason_code: String.t(),
              rejected_at: DateTime.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reject_reason_additional_information: raw["reject_reason_additional_information"],
          reject_reason_code: raw["reject_reason_code"],
          rejected_at: Increase.Decode.datetime(raw["rejected_at"])
        }
      end
    end

    defmodule Submission do
      @moduledoc """
      After the transfer is submitted to FedNow, this will contain supplemental
      details.

      ## Fields

        * `message_identification` - The FedNow network identification of the message submitted.
        * `submitted_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the transfer was submitted to FedNow.
      """

      defstruct [:message_identification, :submitted_at]

      @type t :: %__MODULE__{
              message_identification: String.t(),
              submitted_at: DateTime.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          message_identification: raw["message_identification"],
          submitted_at: Increase.Decode.datetime(raw["submitted_at"])
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number,
      :acknowledgement,
      :amount,
      :created_at,
      :created_by,
      :creditor_address,
      :creditor_name,
      :currency,
      :debtor_address,
      :debtor_name,
      :external_account_id,
      :idempotency_key,
      :pending_transaction_id,
      :rejection,
      :routing_number,
      :source_account_number_id,
      :status,
      :submission,
      :transaction_id,
      :type,
      :unique_end_to_end_transaction_reference,
      :unstructured_remittance_information
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            account_number: String.t(),
            acknowledgement: Acknowledgement.t() | nil,
            amount: integer(),
            created_at: DateTime.t(),
            created_by: CreatedBy.t() | nil,
            creditor_address: CreditorAddress.t() | nil,
            creditor_name: String.t(),
            currency: String.t(),
            debtor_address: DebtorAddress.t() | nil,
            debtor_name: String.t(),
            external_account_id: String.t() | nil,
            idempotency_key: String.t() | nil,
            pending_transaction_id: String.t() | nil,
            rejection: Rejection.t() | nil,
            routing_number: String.t(),
            source_account_number_id: String.t(),
            status: String.t(),
            submission: Submission.t() | nil,
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
        acknowledgement:
          Increase.Decode.struct(raw["acknowledgement"], &Acknowledgement.decode/1),
        amount: raw["amount"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        creditor_address:
          Increase.Decode.struct(raw["creditor_address"], &CreditorAddress.decode/1),
        creditor_name: raw["creditor_name"],
        currency: raw["currency"],
        debtor_address: Increase.Decode.struct(raw["debtor_address"], &DebtorAddress.decode/1),
        debtor_name: raw["debtor_name"],
        external_account_id: raw["external_account_id"],
        idempotency_key: raw["idempotency_key"],
        pending_transaction_id: raw["pending_transaction_id"],
        rejection: Increase.Decode.struct(raw["rejection"], &Rejection.decode/1),
        routing_number: raw["routing_number"],
        source_account_number_id: raw["source_account_number_id"],
        status: raw["status"],
        submission: Increase.Decode.struct(raw["submission"], &Submission.decode/1),
        transaction_id: raw["transaction_id"],
        type: raw["type"],
        unique_end_to_end_transaction_reference: raw["unique_end_to_end_transaction_reference"],
        unstructured_remittance_information: raw["unstructured_remittance_information"]
      }
    end
  end

  @doc """
  Create a FedNow Transfer

  `POST /fednow_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, FednowTransfer.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/fednow_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, FednowTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a FedNow Transfer

  `GET /fednow_transfers/{fednow_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, FednowTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, fednow_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/fednow_transfers/#{fednow_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, FednowTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List FedNow Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  FednowTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /fednow_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/fednow_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &FednowTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Approve a FedNow Transfer

  `POST /fednow_transfers/{fednow_transfer_id}/approve`
  """
  @spec approve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, FednowTransfer.t()} | {:error, Increase.Error.t()}
  def approve(client, fednow_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/fednow_transfers/#{fednow_transfer_id}/approve"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, FednowTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Cancel a pending FedNow Transfer

  `POST /fednow_transfers/{fednow_transfer_id}/cancel`
  """
  @spec cancel(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, FednowTransfer.t()} | {:error, Increase.Error.t()}
  def cancel(client, fednow_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/fednow_transfers/#{fednow_transfer_id}/cancel"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, FednowTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
