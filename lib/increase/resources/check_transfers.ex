defmodule Increase.CheckTransfers do
  @moduledoc """
  Check Transfers move funds from your Increase account by mailing a physical
  check.

  See https://increase.com/documentation/api/check-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CheckTransfer do
    @moduledoc """
    Check Transfers move funds from your Increase account by mailing a physical
    check.

    ## Fields

      * `id` - The Check transfer's identifier.
      * `account_id` - The identifier of the Account from which funds will be transferred.
      * `account_number` - The account number printed on the check.
      * `amount` - The transfer amount in USD cents.
      * `approval` - If your account requires approvals for transfers and the transfer was
        approved, this will contain details of the approval.
      * `approved_inbound_check_deposit_id` - If the Check Transfer was successfully deposited,
        this will contain the identifier of the Inbound
        Check Deposit object with details of the deposit.
        The Inbound Check Deposit object will have
        information about any associated Transactions for
        this Check Transfer.
      * `balance_check` - How the account's available balance should be checked.
      * `cancellation` - If your account requires approvals for transfers and the transfer was
        not approved, this will contain details of the cancellation.
      * `check_number` - The check number printed on the check.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `created_by` - What object created the transfer, either via the API or the dashboard.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the check's
        currency.
      * `fulfillment_method` - Whether Increase will print and mail the check or if you will do
        it yourself.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `mailing` - If the check has been mailed by Increase, this will contain details of the
        shipment.
      * `pending_transaction_id` - The ID for the pending transaction representing the transfer.
        A pending transaction is created when the transfer [requires
        approval](https://increase.com/documentation/transfer-approvals#transfer-approvals)
        by someone else in your organization.
      * `physical_check` - Details relating to the physical check that Increase will print and
        mail. Will be present if and only if `fulfillment_method` is equal to
        `physical_check`.
      * `routing_number` - The routing number printed on the check.
      * `source_account_number_id` - The identifier of the Account Number from which to send the
        transfer and print on the check.
      * `status` - The lifecycle status of the transfer.
      * `stop_payment_request` - After a stop-payment is requested on the check, this will
        contain supplemental details.
      * `submission` - After the transfer is submitted, this will contain supplemental details.
      * `third_party` - Details relating to the custom fulfillment you will perform. Will be
        present if and only if `fulfillment_method` is equal to `third_party`.
      * `type` - A constant representing the object's type. For this resource it will always be
        `check_transfer`.
      * `valid_until_date` - If set, the check will be valid on or before this date. After this
        date, the check transfer will be automatically stopped and deposits
        will not be accepted. For checks printed by Increase, this date is
        included on the check as its expiry.
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

    defmodule Mailing do
      @moduledoc """
      If the check has been mailed by Increase, this will contain details of the
      shipment.

      ## Fields

        * `mailed_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the check was mailed.
      """

      defstruct [:mailed_at]

      @type t :: %__MODULE__{
              mailed_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          mailed_at: Increase.Decode.datetime(raw["mailed_at"])
        }
      end
    end

    defmodule PhysicalCheck do
      @moduledoc """
      Details relating to the physical check that Increase will print and mail.
      Will be present if and only if `fulfillment_method` is equal to
      `physical_check`.

      ## Fields

        * `attachment_file_id` - The ID of the file for the check attachment.
        * `check_voucher_image_file_id` - The ID of the file for the check voucher image.
        * `mailing_address` - Details for where Increase will mail the check.
        * `memo` - The descriptor that will be printed on the memo field on the check.
        * `note` - The descriptor that will be printed on the letter included with the check.
        * `payer` - The payer of the check. This will be printed on the top-left portion of the
          check and defaults to the return address if unspecified.
        * `recipient_name` - The name that will be printed on the check.
        * `return_address` - The return address to be printed on the check.
        * `shipping_method` - The shipping method for the check.
        * `signature` - The signature that will appear on the check.
        * `tracking_updates` - Tracking updates relating to the physical check's delivery.
      """

      defmodule MailingAddress do
        @moduledoc """
        Details for where Increase will mail the check.

        ## Fields

          * `city` - The city of the check's destination.
          * `line1` - The street address of the check's destination.
          * `line2` - The second line of the address of the check's destination.
          * `name` - The name component of the check's mailing address.
          * `phone` - The phone number to be used in case of delivery issues at the check's
            mailing address. Only used for FedEx overnight shipping.
          * `postal_code` - The postal code of the check's destination.
          * `state` - The state of the check's destination.
        """

        defstruct [:city, :line1, :line2, :name, :phone, :postal_code, :state]

        @type t :: %__MODULE__{
                city: String.t() | nil,
                line1: String.t() | nil,
                line2: String.t() | nil,
                name: String.t() | nil,
                phone: String.t() | nil,
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
            name: raw["name"],
            phone: raw["phone"],
            postal_code: raw["postal_code"],
            state: raw["state"]
          }
        end
      end

      defmodule Payer do
        @moduledoc """
        The `CheckTransferPhysicalCheckPayer` object.

        ## Fields

          * `contents` - The contents of the line.
        """

        defstruct [:contents]

        @type t :: %__MODULE__{
                contents: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            contents: raw["contents"]
          }
        end
      end

      defmodule ReturnAddress do
        @moduledoc """
        The return address to be printed on the check.

        ## Fields

          * `city` - The city of the check's destination.
          * `line1` - The street address of the check's destination.
          * `line2` - The second line of the address of the check's destination.
          * `name` - The name component of the check's return address.
          * `phone` - The shipper's phone number to be used in case of delivery issues. Only
            used for FedEx overnight shipping.
          * `postal_code` - The postal code of the check's destination.
          * `state` - The state of the check's destination.
        """

        defstruct [:city, :line1, :line2, :name, :phone, :postal_code, :state]

        @type t :: %__MODULE__{
                city: String.t() | nil,
                line1: String.t() | nil,
                line2: String.t() | nil,
                name: String.t() | nil,
                phone: String.t() | nil,
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
            name: raw["name"],
            phone: raw["phone"],
            postal_code: raw["postal_code"],
            state: raw["state"]
          }
        end
      end

      defmodule Signature do
        @moduledoc """
        The signature that will appear on the check.

        ## Fields

          * `image_file_id` - The ID of a File containing a PNG of the signature.
          * `text` - The text that will appear as the signature on the check in cursive font.
        """

        defstruct [:image_file_id, :text]

        @type t :: %__MODULE__{
                image_file_id: String.t() | nil,
                text: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            image_file_id: raw["image_file_id"],
            text: raw["text"]
          }
        end
      end

      defmodule TrackingUpdate do
        @moduledoc """
        The `CheckTransferPhysicalCheckTrackingUpdate` object.

        ## Fields

          * `category` - The type of tracking event.
          * `country` - The ISO 3166-1 alpha-2 country code for the country where the event took
            place.
          * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
            at which the tracking event took place.
          * `postal_code` - The postal code where the event took place.
        """

        defstruct [:category, :country, :created_at, :postal_code]

        @type t :: %__MODULE__{
                category: String.t(),
                country: String.t(),
                created_at: DateTime.t(),
                postal_code: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            category: raw["category"],
            country: raw["country"],
            created_at: Increase.Decode.datetime(raw["created_at"]),
            postal_code: raw["postal_code"]
          }
        end
      end

      defstruct [
        :attachment_file_id,
        :check_voucher_image_file_id,
        :mailing_address,
        :memo,
        :note,
        :payer,
        :recipient_name,
        :return_address,
        :shipping_method,
        :signature,
        :tracking_updates
      ]

      @type t :: %__MODULE__{
              attachment_file_id: String.t() | nil,
              check_voucher_image_file_id: String.t() | nil,
              mailing_address: MailingAddress.t(),
              memo: String.t() | nil,
              note: String.t() | nil,
              payer: [Payer.t()],
              recipient_name: String.t(),
              return_address: ReturnAddress.t() | nil,
              shipping_method: String.t(),
              signature: Signature.t(),
              tracking_updates: [TrackingUpdate.t()]
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          attachment_file_id: raw["attachment_file_id"],
          check_voucher_image_file_id: raw["check_voucher_image_file_id"],
          mailing_address:
            Increase.Decode.struct(raw["mailing_address"], &MailingAddress.decode/1),
          memo: raw["memo"],
          note: raw["note"],
          payer: Increase.Decode.list(raw["payer"], &Payer.decode/1),
          recipient_name: raw["recipient_name"],
          return_address: Increase.Decode.struct(raw["return_address"], &ReturnAddress.decode/1),
          shipping_method: raw["shipping_method"],
          signature: Increase.Decode.struct(raw["signature"], &Signature.decode/1),
          tracking_updates:
            Increase.Decode.list(raw["tracking_updates"], &TrackingUpdate.decode/1)
        }
      end
    end

    defmodule StopPaymentRequest do
      @moduledoc """
      After a stop-payment is requested on the check, this will contain
      supplemental details.

      ## Fields

        * `reason` - The reason why this transfer was stopped.
        * `requested_at` - The time the stop-payment was requested.
        * `transfer_id` - The ID of the check transfer that was stopped.
        * `type` - A constant representing the object's type. For this resource it will always
          be `check_transfer_stop_payment_request`.
      """

      defstruct [:reason, :requested_at, :transfer_id, :type]

      @type t :: %__MODULE__{
              reason: String.t(),
              requested_at: DateTime.t(),
              transfer_id: String.t(),
              type: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reason: raw["reason"],
          requested_at: Increase.Decode.datetime(raw["requested_at"]),
          transfer_id: raw["transfer_id"],
          type: raw["type"]
        }
      end
    end

    defmodule Submission do
      @moduledoc """
      After the transfer is submitted, this will contain supplemental details.

      ## Fields

        * `preview_file_id` - The ID of the file corresponding to an image of the check that was
          mailed, if available.
        * `submitted_address` - The address we submitted to the printer. This is what is
          physically printed on the check.
        * `submitted_at` - When this check was submitted to our check printer.
        * `tracking_number` - The tracking number for the check shipment.
      """

      defmodule SubmittedAddress do
        @moduledoc """
        The address we submitted to the printer. This is what is physically printed
        on the check.

        ## Fields

          * `city` - The submitted address city.
          * `line1` - The submitted address line 1.
          * `line2` - The submitted address line 2.
          * `recipient_name` - The submitted recipient name.
          * `state` - The submitted address state.
          * `zip` - The submitted address zip.
        """

        defstruct [:city, :line1, :line2, :recipient_name, :state, :zip]

        @type t :: %__MODULE__{
                city: String.t(),
                line1: String.t(),
                line2: String.t() | nil,
                recipient_name: String.t(),
                state: String.t(),
                zip: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            line1: raw["line1"],
            line2: raw["line2"],
            recipient_name: raw["recipient_name"],
            state: raw["state"],
            zip: raw["zip"]
          }
        end
      end

      defstruct [:preview_file_id, :submitted_address, :submitted_at, :tracking_number]

      @type t :: %__MODULE__{
              preview_file_id: String.t() | nil,
              submitted_address: SubmittedAddress.t(),
              submitted_at: DateTime.t(),
              tracking_number: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          preview_file_id: raw["preview_file_id"],
          submitted_address:
            Increase.Decode.struct(raw["submitted_address"], &SubmittedAddress.decode/1),
          submitted_at: Increase.Decode.datetime(raw["submitted_at"]),
          tracking_number: raw["tracking_number"]
        }
      end
    end

    defmodule ThirdParty do
      @moduledoc """
      Details relating to the custom fulfillment you will perform. Will be present
      if and only if `fulfillment_method` is equal to `third_party`.

      ## Fields

        * `recipient_name` - The name that you will print on the check.
      """

      defstruct [:recipient_name]

      @type t :: %__MODULE__{
              recipient_name: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          recipient_name: raw["recipient_name"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number,
      :amount,
      :approval,
      :approved_inbound_check_deposit_id,
      :balance_check,
      :cancellation,
      :check_number,
      :created_at,
      :created_by,
      :currency,
      :fulfillment_method,
      :idempotency_key,
      :mailing,
      :pending_transaction_id,
      :physical_check,
      :routing_number,
      :source_account_number_id,
      :status,
      :stop_payment_request,
      :submission,
      :third_party,
      :type,
      :valid_until_date
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            account_number: String.t(),
            amount: integer(),
            approval: Approval.t() | nil,
            approved_inbound_check_deposit_id: String.t() | nil,
            balance_check: String.t() | nil,
            cancellation: Cancellation.t() | nil,
            check_number: String.t(),
            created_at: DateTime.t(),
            created_by: CreatedBy.t() | nil,
            currency: String.t(),
            fulfillment_method: String.t(),
            idempotency_key: String.t() | nil,
            mailing: Mailing.t() | nil,
            pending_transaction_id: String.t() | nil,
            physical_check: PhysicalCheck.t() | nil,
            routing_number: String.t(),
            source_account_number_id: String.t() | nil,
            status: String.t(),
            stop_payment_request: StopPaymentRequest.t() | nil,
            submission: Submission.t() | nil,
            third_party: ThirdParty.t() | nil,
            type: String.t(),
            valid_until_date: Date.t() | nil
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
        approved_inbound_check_deposit_id: raw["approved_inbound_check_deposit_id"],
        balance_check: raw["balance_check"],
        cancellation: Increase.Decode.struct(raw["cancellation"], &Cancellation.decode/1),
        check_number: raw["check_number"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        currency: raw["currency"],
        fulfillment_method: raw["fulfillment_method"],
        idempotency_key: raw["idempotency_key"],
        mailing: Increase.Decode.struct(raw["mailing"], &Mailing.decode/1),
        pending_transaction_id: raw["pending_transaction_id"],
        physical_check: Increase.Decode.struct(raw["physical_check"], &PhysicalCheck.decode/1),
        routing_number: raw["routing_number"],
        source_account_number_id: raw["source_account_number_id"],
        status: raw["status"],
        stop_payment_request:
          Increase.Decode.struct(raw["stop_payment_request"], &StopPaymentRequest.decode/1),
        submission: Increase.Decode.struct(raw["submission"], &Submission.decode/1),
        third_party: Increase.Decode.struct(raw["third_party"], &ThirdParty.decode/1),
        type: raw["type"],
        valid_until_date: Increase.Decode.date(raw["valid_until_date"])
      }
    end
  end

  @doc """
  Create a Check Transfer

  `POST /check_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, CheckTransfer.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CheckTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Check Transfer

  `GET /check_transfers/{check_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CheckTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, check_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_transfers/#{check_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CheckTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Check Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CheckTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /check_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CheckTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Approve a Check Transfer

  `POST /check_transfers/{check_transfer_id}/approve`
  """
  @spec approve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CheckTransfer.t()} | {:error, Increase.Error.t()}
  def approve(client, check_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_transfers/#{check_transfer_id}/approve"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CheckTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Cancel a Check Transfer with the `pending_approval` status. See [Transfer
  Approvals] for more information.

  `POST /check_transfers/{check_transfer_id}/cancel`
  """
  @spec cancel(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CheckTransfer.t()} | {:error, Increase.Error.t()}
  def cancel(client, check_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_transfers/#{check_transfer_id}/cancel"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CheckTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Stop payment on a Check Transfer

  `POST /check_transfers/{check_transfer_id}/stop_payment`
  """
  @spec stop_payment(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, CheckTransfer.t()} | {:error, Increase.Error.t()}
  def stop_payment(client, check_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/check_transfers/#{check_transfer_id}/stop_payment"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CheckTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
