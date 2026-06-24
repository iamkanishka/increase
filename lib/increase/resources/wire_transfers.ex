defmodule Increase.WireTransfers do
  @moduledoc """
  Wire transfers move funds between your Increase account and any other account
  accessible by Fedwire.

  """

  alias Increase.Client
  alias Increase.Page

  defmodule WireTransfer do
    @moduledoc """
    Wire transfers move funds between your Increase account and any other
    account accessible by Fedwire.

    ## Fields

      * `id` - The wire transfer's identifier.
      * `account_id` - The Account to which the transfer belongs.
      * `account_number` - The destination account number.
      * `amount` - The transfer amount in USD cents.
      * `approval` - If your account requires approvals for transfers and the transfer was
        approved, this will contain details of the approval.
      * `cancellation` - If your account requires approvals for transfers and the transfer was
        not approved, this will contain details of the cancellation.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `created_by` - What object created the transfer, either via the API or the dashboard.
      * `creditor` - The person or business that is receiving the funds from the transfer.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
        transfer's currency. For wire transfers this is always equal to `usd`.
      * `debtor` - The person or business whose funds are being transferred.
      * `external_account_id` - The identifier of the External Account the transfer was made to,
        if any.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `inbound_wire_drawdown_request_id` - The ID of an Inbound Wire Drawdown Request in
        response to which this transfer was sent.
      * `network` - The transfer's network.
      * `pending_transaction_id` - The ID for the pending transaction representing the transfer.
        A pending transaction is created when the transfer [requires
        approval](https://increase.com/documentation/transfer-approvals#transfer-approvals)
        by someone else in your organization.
      * `remittance` - Remittance information sent with the wire transfer.
      * `reversal` - If your transfer is reversed, this will contain details of the reversal.
      * `routing_number` - The American Bankers' Association (ABA) Routing Transit Number (RTN).
      * `source_account_number_id` - The Account Number that was passed to the wire's recipient.
      * `status` - The lifecycle status of the transfer.
      * `submission` - After the transfer is submitted to Fedwire, this will contain
        supplemental details.
      * `transaction_id` - The ID for the transaction funding the transfer.
      * `type` - A constant representing the object's type. For this resource it will always be
        `wire_transfer`.
      * `unique_end_to_end_transaction_reference` - The unique end-to-end transaction reference
        ([UETR](https://www.swift.com/payments/what-unique-end-end-transaction-reference-uetr))
        of the transfer.
    """

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

    defmodule Creditor do
      @moduledoc """
      The person or business that is receiving the funds from the transfer.

      ## Fields

        * `address` - The person or business's address.
        * `name` - The person or business's name.
      """

      defmodule Address do
        @moduledoc """
        The person or business's address.

        ## Fields

          * `unstructured` - Unstructured address lines.
        """

        defmodule Unstructured do
          @moduledoc """
          Unstructured address lines.

          ## Fields

            * `line1` - The first line.
            * `line2` - The second line.
            * `line3` - The third line.
          """

          defstruct [:line1, :line2, :line3]

          @type t :: %__MODULE__{
                  line1: String.t() | nil,
                  line2: String.t() | nil,
                  line3: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              line1: raw["line1"],
              line2: raw["line2"],
              line3: raw["line3"]
            }
          end
        end

        defstruct [:unstructured]

        @type t :: %__MODULE__{
                unstructured: Unstructured.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            unstructured: Increase.Decode.struct(raw["unstructured"], &Unstructured.decode/1)
          }
        end
      end

      defstruct [:address, :name]

      @type t :: %__MODULE__{
              address: Address.t() | nil,
              name: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          name: raw["name"]
        }
      end
    end

    defmodule Debtor do
      @moduledoc """
      The person or business whose funds are being transferred.

      ## Fields

        * `address` - The person or business's address.
        * `name` - The person or business's name.
      """

      defmodule Address do
        @moduledoc """
        The person or business's address.

        ## Fields

          * `unstructured` - Unstructured address lines.
        """

        defmodule Unstructured do
          @moduledoc """
          Unstructured address lines.

          ## Fields

            * `line1` - The first line.
            * `line2` - The second line.
            * `line3` - The third line.
          """

          defstruct [:line1, :line2, :line3]

          @type t :: %__MODULE__{
                  line1: String.t() | nil,
                  line2: String.t() | nil,
                  line3: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              line1: raw["line1"],
              line2: raw["line2"],
              line3: raw["line3"]
            }
          end
        end

        defstruct [:unstructured]

        @type t :: %__MODULE__{
                unstructured: Unstructured.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            unstructured: Increase.Decode.struct(raw["unstructured"], &Unstructured.decode/1)
          }
        end
      end

      defstruct [:address, :name]

      @type t :: %__MODULE__{
              address: Address.t() | nil,
              name: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          name: raw["name"]
        }
      end
    end

    defmodule Remittance do
      @moduledoc """
      Remittance information sent with the wire transfer.

      ## Fields

        * `category` - The type of remittance information being passed.
        * `tax` - Internal Revenue Service (IRS) tax repayment information. Required if
          `category` is equal to `tax`.
        * `unstructured` - Unstructured remittance information. Required if `category` is equal
          to `unstructured`.
      """

      defmodule Tax do
        @moduledoc """
        Internal Revenue Service (IRS) tax repayment information. Required if
        `category` is equal to `tax`.

        ## Fields

          * `date` - The month and year the tax payment is for, in YYYY-MM-DD format. The day is
            ignored.
          * `identification_number` - The 9-digit Tax Identification Number (TIN) or Employer
            Identification Number (EIN).
          * `type_code` - The 5-character tax type code.
        """

        defstruct [:date, :identification_number, :type_code]

        @type t :: %__MODULE__{
                date: Date.t(),
                identification_number: String.t(),
                type_code: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            date: Increase.Decode.date(raw["date"]),
            identification_number: raw["identification_number"],
            type_code: raw["type_code"]
          }
        end
      end

      defmodule Unstructured do
        @moduledoc """
        Unstructured remittance information. Required if `category` is equal to
        `unstructured`.

        ## Fields

          * `message` - The message to the beneficiary.
        """

        defstruct [:message]

        @type t :: %__MODULE__{
                message: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            message: raw["message"]
          }
        end
      end

      defstruct [:category, :tax, :unstructured]

      @type t :: %__MODULE__{
              category: String.t(),
              tax: Tax.t() | nil,
              unstructured: Unstructured.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          category: raw["category"],
          tax: Increase.Decode.struct(raw["tax"], &Tax.decode/1),
          unstructured: Increase.Decode.struct(raw["unstructured"], &Unstructured.decode/1)
        }
      end
    end

    defmodule Reversal do
      @moduledoc """
      If your transfer is reversed, this will contain details of the reversal.

      ## Fields

        * `amount` - The amount that was reversed in USD cents.
        * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the reversal was created.
        * `debtor_routing_number` - The debtor's routing number.
        * `description` - The description on the reversal message from Fedwire, set by the
          reversing bank.
        * `input_cycle_date` - The Fedwire cycle date for the wire reversal. The "Fedwire day"
          begins at 9:00 PM Eastern Time on the evening before the `cycle
          date`.
        * `input_message_accountability_data` - The Fedwire transaction identifier.
        * `input_sequence_number` - The Fedwire sequence number.
        * `input_source` - The Fedwire input source identifier.
        * `instruction_identification` - The sending bank's identifier for the reversal.
        * `return_reason_additional_information` - Additional information about the reason for
          the reversal.
        * `return_reason_code` - A code provided by the sending bank giving a reason for the
          reversal. The common return reason codes are [documented
          here].
        * `return_reason_code_description` - An Increase-generated description of the
          `return_reason_code`.
        * `transaction_id` - The ID for the Transaction associated with the transfer reversal.
        * `wire_transfer_id` - The ID for the Wire Transfer that is being reversed.
      """

      defstruct [
        :amount,
        :created_at,
        :debtor_routing_number,
        :description,
        :input_cycle_date,
        :input_message_accountability_data,
        :input_sequence_number,
        :input_source,
        :instruction_identification,
        :return_reason_additional_information,
        :return_reason_code,
        :return_reason_code_description,
        :transaction_id,
        :wire_transfer_id
      ]

      @type t :: %__MODULE__{
              amount: integer(),
              created_at: DateTime.t(),
              debtor_routing_number: String.t() | nil,
              description: String.t(),
              input_cycle_date: Date.t(),
              input_message_accountability_data: String.t(),
              input_sequence_number: String.t(),
              input_source: String.t(),
              instruction_identification: String.t() | nil,
              return_reason_additional_information: String.t() | nil,
              return_reason_code: String.t() | nil,
              return_reason_code_description: String.t() | nil,
              transaction_id: String.t(),
              wire_transfer_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          amount: raw["amount"],
          created_at: Increase.Decode.datetime(raw["created_at"]),
          debtor_routing_number: raw["debtor_routing_number"],
          description: raw["description"],
          input_cycle_date: Increase.Decode.date(raw["input_cycle_date"]),
          input_message_accountability_data: raw["input_message_accountability_data"],
          input_sequence_number: raw["input_sequence_number"],
          input_source: raw["input_source"],
          instruction_identification: raw["instruction_identification"],
          return_reason_additional_information: raw["return_reason_additional_information"],
          return_reason_code: raw["return_reason_code"],
          return_reason_code_description: raw["return_reason_code_description"],
          transaction_id: raw["transaction_id"],
          wire_transfer_id: raw["wire_transfer_id"]
        }
      end
    end

    defmodule Submission do
      @moduledoc """
      After the transfer is submitted to Fedwire, this will contain supplemental
      details.

      ## Fields

        * `input_message_accountability_data` - The accountability data for the submission.
        * `submitted_at` - When this wire transfer was submitted to Fedwire.
      """

      defstruct [:input_message_accountability_data, :submitted_at]

      @type t :: %__MODULE__{
              input_message_accountability_data: String.t(),
              submitted_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          input_message_accountability_data: raw["input_message_accountability_data"],
          submitted_at: Increase.Decode.datetime(raw["submitted_at"])
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number,
      :amount,
      :approval,
      :cancellation,
      :created_at,
      :created_by,
      :creditor,
      :currency,
      :debtor,
      :external_account_id,
      :idempotency_key,
      :inbound_wire_drawdown_request_id,
      :network,
      :pending_transaction_id,
      :remittance,
      :reversal,
      :routing_number,
      :source_account_number_id,
      :status,
      :submission,
      :transaction_id,
      :type,
      :unique_end_to_end_transaction_reference
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            account_number: String.t(),
            amount: integer(),
            approval: Approval.t() | nil,
            cancellation: Cancellation.t() | nil,
            created_at: DateTime.t(),
            created_by: CreatedBy.t() | nil,
            creditor: Creditor.t() | nil,
            currency: String.t(),
            debtor: Debtor.t() | nil,
            external_account_id: String.t() | nil,
            idempotency_key: String.t() | nil,
            inbound_wire_drawdown_request_id: String.t() | nil,
            network: String.t(),
            pending_transaction_id: String.t() | nil,
            remittance: Remittance.t() | nil,
            reversal: Reversal.t() | nil,
            routing_number: String.t(),
            source_account_number_id: String.t() | nil,
            status: String.t(),
            submission: Submission.t() | nil,
            transaction_id: String.t() | nil,
            type: String.t(),
            unique_end_to_end_transaction_reference: String.t() | nil
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        account_number: raw["account_number"],
        amount: raw["amount"],
        approval: Increase.Decode.struct(raw["approval"], &Approval.decode/1),
        cancellation: Increase.Decode.struct(raw["cancellation"], &Cancellation.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        creditor: Increase.Decode.struct(raw["creditor"], &Creditor.decode/1),
        currency: raw["currency"],
        debtor: Increase.Decode.struct(raw["debtor"], &Debtor.decode/1),
        external_account_id: raw["external_account_id"],
        idempotency_key: raw["idempotency_key"],
        inbound_wire_drawdown_request_id: raw["inbound_wire_drawdown_request_id"],
        network: raw["network"],
        pending_transaction_id: raw["pending_transaction_id"],
        remittance: Increase.Decode.struct(raw["remittance"], &Remittance.decode/1),
        reversal: Increase.Decode.struct(raw["reversal"], &Reversal.decode/1),
        routing_number: raw["routing_number"],
        source_account_number_id: raw["source_account_number_id"],
        status: raw["status"],
        submission: Increase.Decode.struct(raw["submission"], &Submission.decode/1),
        transaction_id: raw["transaction_id"],
        type: raw["type"],
        unique_end_to_end_transaction_reference: raw["unique_end_to_end_transaction_reference"]
      }
    end
  end

  @doc """
  Create a Wire Transfer

  `POST /wire_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, WireTransfer.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, WireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Wire Transfer

  `GET /wire_transfers/{wire_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, WireTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, wire_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_transfers/#{wire_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, WireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Wire Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  WireTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /wire_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &WireTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Approve a Wire Transfer

  `POST /wire_transfers/{wire_transfer_id}/approve`
  """
  @spec approve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, WireTransfer.t()} | {:error, Increase.Error.t()}
  def approve(client, wire_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_transfers/#{wire_transfer_id}/approve"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, WireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Cancel a pending Wire Transfer

  `POST /wire_transfers/{wire_transfer_id}/cancel`
  """
  @spec cancel(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, WireTransfer.t()} | {:error, Increase.Error.t()}
  def cancel(client, wire_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/wire_transfers/#{wire_transfer_id}/cancel"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, WireTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
