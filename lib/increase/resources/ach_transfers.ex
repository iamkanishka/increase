defmodule Increase.ACHTransfers do
  @moduledoc """
  ACH transfers move funds between your Increase account and any other account
  accessible by the Automated Clearing House (ACH).

  See https://increase.com/documentation/api/ach-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule ACHTransfer do
    @moduledoc """
    ACH transfers move funds between your Increase account and any other account
    accessible by the Automated Clearing House (ACH).

    ## Fields

      * `id` - The ACH transfer's identifier.
      * `account_id` - The Account to which the transfer belongs.
      * `account_number` - The destination account number.
      * `acknowledgement` - After the transfer is acknowledged by FedACH, this will contain
        supplemental details. The Federal Reserve sends an acknowledgement
        message for each file that Increase submits.
      * `addenda` - Additional information that will be sent to the recipient.
      * `amount` - The transfer amount in USD cents. A positive amount indicates a credit
        transfer pushing funds to the receiving account. A negative amount indicates
        a debit transfer pulling funds from the receiving account.
      * `approval` - If your account requires approvals for transfers and the transfer was
        approved, this will contain details of the approval.
      * `cancellation` - If your account requires approvals for transfers and the transfer was
        not approved, this will contain details of the cancellation.
      * `company_descriptive_date` - The description of the date of the transfer.
      * `company_discretionary_data` - The data you chose to associate with the transfer.
      * `company_entry_description` - The description of the transfer you set to be shown to the
        recipient.
      * `company_id` - The company ID associated with the transfer.
      * `company_name` - The name by which the recipient knows you.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the transfer was created.
      * `created_by` - What object created the transfer, either via the API or the dashboard.
      * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
        transfer's currency. For ACH transfers this is always equal to `usd`.
      * `destination_account_holder` - The type of entity that owns the account to which the ACH
        Transfer is being sent.
      * `external_account_id` - The identifier of the External Account the transfer was made to,
        if any.
      * `funding` - The type of the account to which the transfer will be sent.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `inbound_funds_hold` - Increase will sometimes hold the funds for ACH debit transfers.
        If funds are held, this sub-object will contain details of the
        hold.
      * `individual_id` - Your identifier for the transfer recipient.
      * `individual_name` - The name of the transfer recipient. This value is informational and
        not verified by the recipient's bank.
      * `network` - The transfer's network.
      * `notifications_of_change` - If the receiving bank notifies that future transfers should
        use different details, this will contain those details.
      * `pending_transaction_id` - The ID for the pending transaction representing the transfer.
        A pending transaction is created when the transfer [requires
        approval](https://increase.com/documentation/transfer-approvals#transfer-approvals)
        by someone else in your organization.
      * `preferred_effective_date` - Configuration for how the effective date of the transfer
        will be set. This determines same-day vs future-dated
        settlement timing. If not set, defaults to a
        `settlement_schedule` of `same_day`. If set, exactly one of
        the child attributes must be set.
      * `return` - If your transfer is returned, this will contain details of the return.
      * `routing_number` - The American Bankers' Association (ABA) Routing Transit Number (RTN).
      * `settlement` - A subhash containing information about when and how the transfer settled
        at the Federal Reserve.
      * `standard_entry_class_code` - The [Standard Entry Class (SEC)
        code]to
        use for the transfer.
      * `statement_descriptor` - The descriptor that will show on the recipient's bank
        statement.
      * `status` - The lifecycle status of the transfer.
      * `submission` - After the transfer is submitted to FedACH, this will contain supplemental
        details. Increase batches transfers and submits a file to the Federal
        Reserve roughly every 30 minutes. The Federal Reserve processes ACH
        transfers during weekdays according to their [posted
        schedule](https://www.frbservices.org/resources/resource-centers/same-day-ach/fedach-processing-schedule.html).
      * `transaction_id` - The ID for the transaction funding the transfer.
      * `type` - A constant representing the object's type. For this resource it will always be
        `ach_transfer`.
    """

    defmodule Acknowledgement do
      @moduledoc """
      After the transfer is acknowledged by FedACH, this will contain supplemental
      details. The Federal Reserve sends an acknowledgement message for each file
      that Increase submits.

      ## Fields

        * `acknowledged_at` - When the Federal Reserve acknowledged the submitted file
          containing this transfer.
      """

      defstruct [:acknowledged_at]

      @type t :: %__MODULE__{
              acknowledged_at: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          acknowledged_at: raw["acknowledged_at"]
        }
      end
    end

    defmodule Addenda do
      @moduledoc """
      Additional information that will be sent to the recipient.

      ## Fields

        * `category` - The type of the resource. We may add additional possible values for this
          enum over time; your application should be able to handle such additions
          gracefully.
        * `freeform` - Unstructured `payment_related_information` passed through with the
          transfer.
        * `payment_order_remittance_advice` - Structured ASC X12 820 remittance advice records.
          Please reach out to
          [support@increase.com](mailto:support@increase.com)
          for more information.
      """

      defmodule Freeform do
        @moduledoc """
        Unstructured `payment_related_information` passed through with the transfer.

        ## Fields

          * `entries` - Each entry represents an addendum sent with the transfer.
        """

        defmodule Entry do
          @moduledoc """
          The `ACHTransferAddendaFreeformEntry` object.

          ## Fields

            * `payment_related_information` - The payment related information passed in the
              addendum.
          """

          defstruct [:payment_related_information]

          @type t :: %__MODULE__{
                  payment_related_information: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              payment_related_information: raw["payment_related_information"]
            }
          end
        end

        defstruct [:entries]

        @type t :: %__MODULE__{
                entries: [Entry.t()]
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            entries: Increase.Decode.list(raw["entries"], &Entry.decode/1)
          }
        end
      end

      defmodule PaymentOrderRemittanceAdvice do
        @moduledoc """
        Structured ASC X12 820 remittance advice records. Please reach out to
        [support@increase.com](mailto:support@increase.com) for more information.

        ## Fields

          * `invoices` - ASC X12 RMR records for this specific transfer.
        """

        defmodule Invoice do
          @moduledoc """
          The `ACHTransferAddendaPaymentOrderRemittanceAdviceInvoice` object.

          ## Fields

            * `invoice_number` - The invoice number for this reference, determined in advance
              with the receiver.
            * `paid_amount` - The amount that was paid for this invoice in the minor unit of its
              currency. For dollars, for example, this is cents.
          """

          defstruct [:invoice_number, :paid_amount]

          @type t :: %__MODULE__{
                  invoice_number: String.t(),
                  paid_amount: integer()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              invoice_number: raw["invoice_number"],
              paid_amount: raw["paid_amount"]
            }
          end
        end

        defstruct [:invoices]

        @type t :: %__MODULE__{
                invoices: [Invoice.t()]
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            invoices: Increase.Decode.list(raw["invoices"], &Invoice.decode/1)
          }
        end
      end

      defstruct [:category, :freeform, :payment_order_remittance_advice]

      @type t :: %__MODULE__{
              category: String.t(),
              freeform: Freeform.t() | nil,
              payment_order_remittance_advice: PaymentOrderRemittanceAdvice.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          category: raw["category"],
          freeform: Increase.Decode.struct(raw["freeform"], &Freeform.decode/1),
          payment_order_remittance_advice:
            Increase.Decode.struct(
              raw["payment_order_remittance_advice"],
              &PaymentOrderRemittanceAdvice.decode/1
            )
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

    defmodule InboundFundsHold do
      @moduledoc """
      Increase will sometimes hold the funds for ACH debit transfers. If funds are
      held, this sub-object will contain details of the hold.

      ## Fields

        * `amount` - The held amount in the minor unit of the account's currency. For dollars,
          for example, this is cents.
        * `automatically_releases_at` - When the hold will be released automatically. Certain
          conditions may cause it to be released before this time.
        * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which
          the hold was created.
        * `currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for the
          hold's currency.
        * `held_transaction_id` - The ID of the Transaction for which funds were held.
        * `pending_transaction_id` - The ID of the Pending Transaction representing the held
          funds.
        * `released_at` - When the hold was released (if it has been released).
        * `status` - The status of the hold.
        * `type` - A constant representing the object's type. For this resource it will always
          be `inbound_funds_hold`.
      """

      defstruct [
        :amount,
        :automatically_releases_at,
        :created_at,
        :currency,
        :held_transaction_id,
        :pending_transaction_id,
        :released_at,
        :status,
        :type
      ]

      @type t :: %__MODULE__{
              amount: integer(),
              automatically_releases_at: DateTime.t(),
              created_at: DateTime.t(),
              currency: String.t(),
              held_transaction_id: String.t() | nil,
              pending_transaction_id: String.t() | nil,
              released_at: DateTime.t() | nil,
              status: String.t(),
              type: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          amount: raw["amount"],
          automatically_releases_at: Increase.Decode.datetime(raw["automatically_releases_at"]),
          created_at: Increase.Decode.datetime(raw["created_at"]),
          currency: raw["currency"],
          held_transaction_id: raw["held_transaction_id"],
          pending_transaction_id: raw["pending_transaction_id"],
          released_at: Increase.Decode.datetime(raw["released_at"]),
          status: raw["status"],
          type: raw["type"]
        }
      end
    end

    defmodule NotificationsOfChange do
      @moduledoc """
      The `ACHTransferNotificationsOfChange` object.

      ## Fields

        * `change_code` - The required type of change that is being signaled by the receiving
          financial institution.
        * `corrected_account_funding` - The corrected account funding type that should be used
          in future ACHs to this account. This is derived from the
          corrected transaction code.
        * `corrected_account_number` - The corrected account number that should be used in
          future ACHs to this account.
        * `corrected_individual_id` - The corrected individual identifier that should be used in
          future ACHs.
        * `corrected_routing_number` - The corrected routing number that should be used in
          future ACHs to this account.
        * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the notification occurred.
      """

      defstruct [
        :change_code,
        :corrected_account_funding,
        :corrected_account_number,
        :corrected_individual_id,
        :corrected_routing_number,
        :created_at
      ]

      @type t :: %__MODULE__{
              change_code: String.t(),
              corrected_account_funding: String.t() | nil,
              corrected_account_number: String.t() | nil,
              corrected_individual_id: String.t() | nil,
              corrected_routing_number: String.t() | nil,
              created_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          change_code: raw["change_code"],
          corrected_account_funding: raw["corrected_account_funding"],
          corrected_account_number: raw["corrected_account_number"],
          corrected_individual_id: raw["corrected_individual_id"],
          corrected_routing_number: raw["corrected_routing_number"],
          created_at: Increase.Decode.datetime(raw["created_at"])
        }
      end
    end

    defmodule PreferredEffectiveDate do
      @moduledoc """
      Configuration for how the effective date of the transfer will be set. This
      determines same-day vs future-dated settlement timing. If not set, defaults
      to a `settlement_schedule` of `same_day`. If set, exactly one of the child
      attributes must be set.

      ## Fields

        * `date` - A specific date in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format
          to use as the effective date when submitting this transfer.
        * `settlement_schedule` - A schedule by which Increase will choose an effective date for
          the transfer.
      """

      defstruct [:date, :settlement_schedule]

      @type t :: %__MODULE__{
              date: Date.t() | nil,
              settlement_schedule: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          date: Increase.Decode.date(raw["date"]),
          settlement_schedule: raw["settlement_schedule"]
        }
      end
    end

    defmodule Return do
      @moduledoc """
      If your transfer is returned, this will contain details of the return.

      ## Fields

        * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the transfer was created.
        * `raw_return_reason_code` - The three character ACH return code, in the range R01 to
          R85.
        * `return_reason_code` - Why the ACH Transfer was returned. This reason code is sent by
          the receiving bank back to Increase.
        * `trace_number` - A 15 digit number that was generated by the bank that initiated the
          return. The trace number of the return is different than that of the
          original transfer. ACH trace numbers are not unique, but along with
          the amount and date this number can be used to identify the ACH
          return at the bank that initiated it.
        * `transaction_id` - The identifier of the Transaction associated with this return.
        * `transfer_id` - The identifier of the ACH Transfer associated with this return.
      """

      defstruct [
        :created_at,
        :raw_return_reason_code,
        :return_reason_code,
        :trace_number,
        :transaction_id,
        :transfer_id
      ]

      @type t :: %__MODULE__{
              created_at: DateTime.t(),
              raw_return_reason_code: String.t(),
              return_reason_code: String.t(),
              trace_number: String.t(),
              transaction_id: String.t(),
              transfer_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          created_at: Increase.Decode.datetime(raw["created_at"]),
          raw_return_reason_code: raw["raw_return_reason_code"],
          return_reason_code: raw["return_reason_code"],
          trace_number: raw["trace_number"],
          transaction_id: raw["transaction_id"],
          transfer_id: raw["transfer_id"]
        }
      end
    end

    defmodule Settlement do
      @moduledoc """
      A subhash containing information about when and how the transfer settled at
      the Federal Reserve.

      ## Fields

        * `settled_at` - When the funds for this transfer have settled at the destination bank
          at the Federal Reserve.
      """

      defstruct [:settled_at]

      @type t :: %__MODULE__{
              settled_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          settled_at: Increase.Decode.datetime(raw["settled_at"])
        }
      end
    end

    defmodule Submission do
      @moduledoc """
      After the transfer is submitted to FedACH, this will contain supplemental
      details. Increase batches transfers and submits a file to the Federal
      Reserve roughly every 30 minutes. The Federal Reserve processes ACH
      transfers during weekdays according to their [posted
      schedule](https://www.frbservices.org/resources/resource-centers/same-day-ach/fedach-processing-schedule.html).

      ## Fields

        * `administrative_returns_expected_by` - The timestamp by which any administrative
          returns are expected to be received by. This
          follows the NACHA guidelines for return
          windows, which are: "In general, return entries
          must be received by the RDFI’s ACH Operator by
          its deposit deadline for the return entry to be
          made available to the ODFI no later than the
          opening of business on the second banking day
          following the Settlement Date of the original
          entry.".
        * `effective_date` - The ACH transfer's effective date as sent to the Federal Reserve.
          If a specific date was configured using `preferred_effective_date`,
          this will match that value. Otherwise, it will be the date selected
          (following the specified settlement schedule) at the time the
          transfer was submitted.
        * `expected_funds_settlement_at` - When the transfer is expected to settle in the
          recipient's account. Credits may be available sooner,
          at the receiving bank's discretion. The FedACH
          schedule is published
          [here](https://www.frbservices.org/resources/resource-centers/same-day-ach/fedach-processing-schedule.html).
        * `expected_settlement_schedule` - The settlement schedule the transfer is expected to
          follow. This expectation takes into account the
          `effective_date`, `submitted_at`, and the amount of
          the transfer.
        * `submitted_at` - When the ACH transfer was sent to FedACH.
        * `trace_number` - A 15 digit number recorded in the Nacha file and transmitted to the
          receiving bank. Along with the amount, date, and originating routing
          number, this can be used to identify the ACH transfer at the
          receiving bank. ACH trace numbers are not unique, but are [used to
          correlate
          returns](https://increase.com/documentation/ach-returns#ach-returns).
      """

      defstruct [
        :administrative_returns_expected_by,
        :effective_date,
        :expected_funds_settlement_at,
        :expected_settlement_schedule,
        :submitted_at,
        :trace_number
      ]

      @type t :: %__MODULE__{
              administrative_returns_expected_by: DateTime.t(),
              effective_date: Date.t(),
              expected_funds_settlement_at: DateTime.t(),
              expected_settlement_schedule: String.t(),
              submitted_at: DateTime.t(),
              trace_number: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          administrative_returns_expected_by:
            Increase.Decode.datetime(raw["administrative_returns_expected_by"]),
          effective_date: Increase.Decode.date(raw["effective_date"]),
          expected_funds_settlement_at:
            Increase.Decode.datetime(raw["expected_funds_settlement_at"]),
          expected_settlement_schedule: raw["expected_settlement_schedule"],
          submitted_at: Increase.Decode.datetime(raw["submitted_at"]),
          trace_number: raw["trace_number"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number,
      :acknowledgement,
      :addenda,
      :amount,
      :approval,
      :cancellation,
      :company_descriptive_date,
      :company_discretionary_data,
      :company_entry_description,
      :company_id,
      :company_name,
      :created_at,
      :created_by,
      :currency,
      :destination_account_holder,
      :external_account_id,
      :funding,
      :idempotency_key,
      :inbound_funds_hold,
      :individual_id,
      :individual_name,
      :network,
      :notifications_of_change,
      :pending_transaction_id,
      :preferred_effective_date,
      :return,
      :routing_number,
      :settlement,
      :standard_entry_class_code,
      :statement_descriptor,
      :status,
      :submission,
      :transaction_id,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            account_number: String.t(),
            acknowledgement: Acknowledgement.t() | nil,
            addenda: Addenda.t() | nil,
            amount: integer(),
            approval: Approval.t() | nil,
            cancellation: Cancellation.t() | nil,
            company_descriptive_date: String.t() | nil,
            company_discretionary_data: String.t() | nil,
            company_entry_description: String.t() | nil,
            company_id: String.t(),
            company_name: String.t() | nil,
            created_at: DateTime.t(),
            created_by: CreatedBy.t() | nil,
            currency: String.t(),
            destination_account_holder: String.t(),
            external_account_id: String.t() | nil,
            funding: String.t(),
            idempotency_key: String.t() | nil,
            inbound_funds_hold: InboundFundsHold.t() | nil,
            individual_id: String.t() | nil,
            individual_name: String.t() | nil,
            network: String.t(),
            notifications_of_change: [NotificationsOfChange.t()],
            pending_transaction_id: String.t() | nil,
            preferred_effective_date: PreferredEffectiveDate.t(),
            return: Return.t() | nil,
            routing_number: String.t(),
            settlement: Settlement.t() | nil,
            standard_entry_class_code: String.t(),
            statement_descriptor: String.t(),
            status: String.t(),
            submission: Submission.t() | nil,
            transaction_id: String.t() | nil,
            type: String.t()
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
        addenda: Increase.Decode.struct(raw["addenda"], &Addenda.decode/1),
        amount: raw["amount"],
        approval: Increase.Decode.struct(raw["approval"], &Approval.decode/1),
        cancellation: Increase.Decode.struct(raw["cancellation"], &Cancellation.decode/1),
        company_descriptive_date: raw["company_descriptive_date"],
        company_discretionary_data: raw["company_discretionary_data"],
        company_entry_description: raw["company_entry_description"],
        company_id: raw["company_id"],
        company_name: raw["company_name"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        created_by: Increase.Decode.struct(raw["created_by"], &CreatedBy.decode/1),
        currency: raw["currency"],
        destination_account_holder: raw["destination_account_holder"],
        external_account_id: raw["external_account_id"],
        funding: raw["funding"],
        idempotency_key: raw["idempotency_key"],
        inbound_funds_hold:
          Increase.Decode.struct(raw["inbound_funds_hold"], &InboundFundsHold.decode/1),
        individual_id: raw["individual_id"],
        individual_name: raw["individual_name"],
        network: raw["network"],
        notifications_of_change:
          Increase.Decode.list(raw["notifications_of_change"], &NotificationsOfChange.decode/1),
        pending_transaction_id: raw["pending_transaction_id"],
        preferred_effective_date:
          Increase.Decode.struct(
            raw["preferred_effective_date"],
            &PreferredEffectiveDate.decode/1
          ),
        return: Increase.Decode.struct(raw["return"], &Return.decode/1),
        routing_number: raw["routing_number"],
        settlement: Increase.Decode.struct(raw["settlement"], &Settlement.decode/1),
        standard_entry_class_code: raw["standard_entry_class_code"],
        statement_descriptor: raw["statement_descriptor"],
        status: raw["status"],
        submission: Increase.Decode.struct(raw["submission"], &Submission.decode/1),
        transaction_id: raw["transaction_id"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an ACH Transfer

  `POST /ach_transfers`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, ACHTransfer.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_transfers"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an ACH Transfer

  `GET /ach_transfers/{ach_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, ACHTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, ach_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_transfers/#{ach_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List ACH Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  ACHTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /ach_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &ACHTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Approves an ACH Transfer in a pending_approval state.

  `POST /ach_transfers/{ach_transfer_id}/approve`
  """
  @spec approve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, ACHTransfer.t()} | {:error, Increase.Error.t()}
  def approve(client, ach_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_transfers/#{ach_transfer_id}/approve"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Cancels an ACH Transfer in a pending_approval state.

  `POST /ach_transfers/{ach_transfer_id}/cancel`
  """
  @spec cancel(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, ACHTransfer.t()} | {:error, Increase.Error.t()}
  def cancel(client, ach_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_transfers/#{ach_transfer_id}/cancel"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, ACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
