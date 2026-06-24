defmodule Increase.InboundACHTransfers do
  @moduledoc """
  An Inbound ACH Transfer is an ACH transfer initiated outside of Increase to your
  account.

  See https://increase.com/documentation/api/inbound-ach-transfers for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule InboundACHTransfer do
    @moduledoc """
    An Inbound ACH Transfer is an ACH transfer initiated outside of Increase to
    your account.

    ## Fields

      * `id` - The inbound ACH transfer's identifier.
      * `acceptance` - If your transfer is accepted, this will contain details of the
        acceptance.
      * `account_id` - The Account to which the transfer belongs.
      * `account_number_id` - The identifier of the Account Number to which this transfer was
        sent.
      * `addenda` - Additional information sent from the originator.
      * `amount` - The transfer amount in USD cents.
      * `automatically_resolves_at` - The time at which the transfer will be automatically
        resolved.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the inbound ACH transfer was created.
      * `decline` - If your transfer is declined, this will contain details of the decline.
      * `direction` - The direction of the transfer.
      * `effective_date` - The effective date of the transfer. This is sent by the sending bank
        and is a factor in determining funds availability.
      * `international_addenda` - If the Inbound ACH Transfer has a Standard Entry Class Code of
        IAT, this will contain fields pertaining to the International
        ACH Transaction.
      * `notification_of_change` - If you initiate a notification of change in response to the
        transfer, this will contain its details.
      * `originator_company_descriptive_date` - The descriptive date of the transfer.
      * `originator_company_discretionary_data` - The additional information included with the
        transfer.
      * `originator_company_entry_description` - The description of the transfer.
      * `originator_company_id` - The id of the company that initiated the transfer.
      * `originator_company_name` - The name of the company that initiated the transfer.
      * `originator_routing_number` - The American Banking Association (ABA) routing number of
        the bank originating the transfer.
      * `receiver_id_number` - The id of the receiver of the transfer.
      * `receiver_name` - The name of the receiver of the transfer.
      * `settlement` - A subhash containing information about when and how the transfer settled
        at the Federal Reserve.
      * `standard_entry_class_code` - The Standard Entry Class (SEC) code of the transfer.
      * `status` - The status of the transfer.
      * `trace_number` - A 15 digit number set by the sending bank and transmitted to the
        receiving bank. Along with the amount, date, and originating routing
        number, this can be used to identify the ACH transfer. ACH trace
        numbers are not unique, but are [used to correlate
        returns](https://increase.com/documentation/ach-returns#ach-returns).
      * `transfer_return` - If your transfer is returned, this will contain details of the
        return.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_ach_transfer`.
    """

    defmodule Acceptance do
      @moduledoc """
      If your transfer is accepted, this will contain details of the acceptance.

      ## Fields

        * `accepted_at` - The time at which the transfer was accepted.
        * `transaction_id` - The id of the transaction for the accepted transfer.
      """

      defstruct [:accepted_at, :transaction_id]

      @type t :: %__MODULE__{
              accepted_at: DateTime.t(),
              transaction_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          accepted_at: Increase.Decode.datetime(raw["accepted_at"]),
          transaction_id: raw["transaction_id"]
        }
      end
    end

    defmodule Addenda do
      @moduledoc """
      Additional information sent from the originator.

      ## Fields

        * `category` - The type of addendum.
        * `freeform` - Unstructured `payment_related_information` passed through by the
          originator.
      """

      defmodule Freeform do
        @moduledoc """
        Unstructured `payment_related_information` passed through by the originator.

        ## Fields

          * `entries` - Each entry represents an addendum received from the originator.
        """

        defmodule Entry do
          @moduledoc """
          The `InboundACHTransferAddendaFreeformEntry` object.

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

      defstruct [:category, :freeform]

      @type t :: %__MODULE__{
              category: String.t(),
              freeform: Freeform.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          category: raw["category"],
          freeform: Increase.Decode.struct(raw["freeform"], &Freeform.decode/1)
        }
      end
    end

    defmodule Decline do
      @moduledoc """
      If your transfer is declined, this will contain details of the decline.

      ## Fields

        * `declined_at` - The time at which the transfer was declined.
        * `declined_transaction_id` - The id of the transaction for the declined transfer.
        * `reason` - The reason for the transfer decline.
      """

      defstruct [:declined_at, :declined_transaction_id, :reason]

      @type t :: %__MODULE__{
              declined_at: DateTime.t(),
              declined_transaction_id: String.t(),
              reason: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          declined_at: Increase.Decode.datetime(raw["declined_at"]),
          declined_transaction_id: raw["declined_transaction_id"],
          reason: raw["reason"]
        }
      end
    end

    defmodule InternationalAddenda do
      @moduledoc """
      If the Inbound ACH Transfer has a Standard Entry Class Code of IAT, this
      will contain fields pertaining to the International ACH Transaction.

      ## Fields

        * `destination_country_code` - The [ISO
          3166](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2),
          Alpha-2 country code of the destination country.
        * `destination_currency_code` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217)
          currency code for the destination bank account.
        * `foreign_exchange_indicator` - A description of how the foreign exchange rate was
          calculated.
        * `foreign_exchange_reference` - Depending on the
          `foreign_exchange_reference_indicator`, an exchange
          rate or a reference to a well-known rate.
        * `foreign_exchange_reference_indicator` - An instruction of how to interpret the
          `foreign_exchange_reference` field for this
          Transaction.
        * `foreign_payment_amount` - The amount in the minor unit of the foreign payment
          currency. For dollars, for example, this is cents.
        * `foreign_trace_number` - A reference number in the foreign banking infrastructure.
        * `international_transaction_type_code` - The type of transfer. Set by the originator.
        * `originating_currency_code` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217)
          currency code for the originating bank account.
        * `originating_depository_financial_institution_branch_country` - The [ISO
          3166](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2),
          Alpha-2 country code
          of the originating
          branch country.
        * `originating_depository_financial_institution_id` - An identifier for the originating
          bank. One of an International Bank
          Account Number (IBAN) bank
          identifier, SWIFT Bank
          Identification Code (BIC), or a
          domestic identifier like a US
          Routing Number.
        * `originating_depository_financial_institution_id_qualifier` - An instruction of how to
          interpret the
          `originating_depository_financial_institution_id`
          field for this
          Transaction.
        * `originating_depository_financial_institution_name` - The name of the originating
          bank. Sometimes this will refer
          to an American bank and obscure
          the correspondent foreign bank.
        * `originator_city` - A portion of the originator address. This may be incomplete.
        * `originator_country` - A portion of the originator address. The [ISO
          3166](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2),
          Alpha-2 country code of the originator country.
        * `originator_identification` - An identifier for the originating company. This is
          generally stable across multiple ACH transfers.
        * `originator_name` - Either the name of the originator or an intermediary money
          transmitter.
        * `originator_postal_code` - A portion of the originator address. This may be
          incomplete.
        * `originator_state_or_province` - A portion of the originator address. This may be
          incomplete.
        * `originator_street_address` - A portion of the originator address. This may be
          incomplete.
        * `payment_related_information` - A description field set by the originator.
        * `payment_related_information2` - A description field set by the originator.
        * `receiver_city` - A portion of the receiver address. This may be incomplete.
        * `receiver_country` - A portion of the receiver address. The [ISO
          3166](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), Alpha-2
          country code of the receiver country.
        * `receiver_identification_number` - An identification number the originator uses for
          the receiver.
        * `receiver_postal_code` - A portion of the receiver address. This may be incomplete.
        * `receiver_state_or_province` - A portion of the receiver address. This may be
          incomplete.
        * `receiver_street_address` - A portion of the receiver address. This may be incomplete.
        * `receiving_company_or_individual_name` - The name of the receiver of the transfer.
          This is not verified by Increase.
        * `receiving_depository_financial_institution_country` - The [ISO
          3166](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2),
          Alpha-2 country code of the
          receiving bank country.
        * `receiving_depository_financial_institution_id` - An identifier for the receiving
          bank. One of an International Bank
          Account Number (IBAN) bank
          identifier, SWIFT Bank
          Identification Code (BIC), or a
          domestic identifier like a US
          Routing Number.
        * `receiving_depository_financial_institution_id_qualifier` - An instruction of how to
          interpret the
          `receiving_depository_financial_institution_id`
          field for this
          Transaction.
        * `receiving_depository_financial_institution_name` - The name of the receiving bank, as
          set by the sending financial
          institution.
      """

      defstruct [
        :destination_country_code,
        :destination_currency_code,
        :foreign_exchange_indicator,
        :foreign_exchange_reference,
        :foreign_exchange_reference_indicator,
        :foreign_payment_amount,
        :foreign_trace_number,
        :international_transaction_type_code,
        :originating_currency_code,
        :originating_depository_financial_institution_branch_country,
        :originating_depository_financial_institution_id,
        :originating_depository_financial_institution_id_qualifier,
        :originating_depository_financial_institution_name,
        :originator_city,
        :originator_country,
        :originator_identification,
        :originator_name,
        :originator_postal_code,
        :originator_state_or_province,
        :originator_street_address,
        :payment_related_information,
        :payment_related_information2,
        :receiver_city,
        :receiver_country,
        :receiver_identification_number,
        :receiver_postal_code,
        :receiver_state_or_province,
        :receiver_street_address,
        :receiving_company_or_individual_name,
        :receiving_depository_financial_institution_country,
        :receiving_depository_financial_institution_id,
        :receiving_depository_financial_institution_id_qualifier,
        :receiving_depository_financial_institution_name
      ]

      @type t :: %__MODULE__{
              destination_country_code: String.t(),
              destination_currency_code: String.t(),
              foreign_exchange_indicator: String.t(),
              foreign_exchange_reference: String.t() | nil,
              foreign_exchange_reference_indicator: String.t(),
              foreign_payment_amount: integer(),
              foreign_trace_number: String.t() | nil,
              international_transaction_type_code: String.t(),
              originating_currency_code: String.t(),
              originating_depository_financial_institution_branch_country: String.t(),
              originating_depository_financial_institution_id: String.t(),
              originating_depository_financial_institution_id_qualifier: String.t(),
              originating_depository_financial_institution_name: String.t(),
              originator_city: String.t(),
              originator_country: String.t(),
              originator_identification: String.t(),
              originator_name: String.t(),
              originator_postal_code: String.t() | nil,
              originator_state_or_province: String.t() | nil,
              originator_street_address: String.t(),
              payment_related_information: String.t() | nil,
              payment_related_information2: String.t() | nil,
              receiver_city: String.t(),
              receiver_country: String.t(),
              receiver_identification_number: String.t() | nil,
              receiver_postal_code: String.t() | nil,
              receiver_state_or_province: String.t() | nil,
              receiver_street_address: String.t(),
              receiving_company_or_individual_name: String.t(),
              receiving_depository_financial_institution_country: String.t(),
              receiving_depository_financial_institution_id: String.t(),
              receiving_depository_financial_institution_id_qualifier: String.t(),
              receiving_depository_financial_institution_name: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          destination_country_code: raw["destination_country_code"],
          destination_currency_code: raw["destination_currency_code"],
          foreign_exchange_indicator: raw["foreign_exchange_indicator"],
          foreign_exchange_reference: raw["foreign_exchange_reference"],
          foreign_exchange_reference_indicator: raw["foreign_exchange_reference_indicator"],
          foreign_payment_amount: raw["foreign_payment_amount"],
          foreign_trace_number: raw["foreign_trace_number"],
          international_transaction_type_code: raw["international_transaction_type_code"],
          originating_currency_code: raw["originating_currency_code"],
          originating_depository_financial_institution_branch_country:
            raw["originating_depository_financial_institution_branch_country"],
          originating_depository_financial_institution_id:
            raw["originating_depository_financial_institution_id"],
          originating_depository_financial_institution_id_qualifier:
            raw["originating_depository_financial_institution_id_qualifier"],
          originating_depository_financial_institution_name:
            raw["originating_depository_financial_institution_name"],
          originator_city: raw["originator_city"],
          originator_country: raw["originator_country"],
          originator_identification: raw["originator_identification"],
          originator_name: raw["originator_name"],
          originator_postal_code: raw["originator_postal_code"],
          originator_state_or_province: raw["originator_state_or_province"],
          originator_street_address: raw["originator_street_address"],
          payment_related_information: raw["payment_related_information"],
          payment_related_information2: raw["payment_related_information2"],
          receiver_city: raw["receiver_city"],
          receiver_country: raw["receiver_country"],
          receiver_identification_number: raw["receiver_identification_number"],
          receiver_postal_code: raw["receiver_postal_code"],
          receiver_state_or_province: raw["receiver_state_or_province"],
          receiver_street_address: raw["receiver_street_address"],
          receiving_company_or_individual_name: raw["receiving_company_or_individual_name"],
          receiving_depository_financial_institution_country:
            raw["receiving_depository_financial_institution_country"],
          receiving_depository_financial_institution_id:
            raw["receiving_depository_financial_institution_id"],
          receiving_depository_financial_institution_id_qualifier:
            raw["receiving_depository_financial_institution_id_qualifier"],
          receiving_depository_financial_institution_name:
            raw["receiving_depository_financial_institution_name"]
        }
      end
    end

    defmodule NotificationOfChange do
      @moduledoc """
      If you initiate a notification of change in response to the transfer, this
      will contain its details.

      ## Fields

        * `updated_account_number` - The new account number provided in the notification of
          change.
        * `updated_routing_number` - The new routing number provided in the notification of
          change.
      """

      defstruct [:updated_account_number, :updated_routing_number]

      @type t :: %__MODULE__{
              updated_account_number: String.t() | nil,
              updated_routing_number: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          updated_account_number: raw["updated_account_number"],
          updated_routing_number: raw["updated_routing_number"]
        }
      end
    end

    defmodule Settlement do
      @moduledoc """
      A subhash containing information about when and how the transfer settled at
      the Federal Reserve.

      ## Fields

        * `settled_at` - When the funds for this transfer settle at the recipient bank at the
          Federal Reserve.
        * `settlement_schedule` - The settlement schedule this transfer follows.
      """

      defstruct [:settled_at, :settlement_schedule]

      @type t :: %__MODULE__{
              settled_at: DateTime.t(),
              settlement_schedule: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          settled_at: Increase.Decode.datetime(raw["settled_at"]),
          settlement_schedule: raw["settlement_schedule"]
        }
      end
    end

    defmodule TransferReturn do
      @moduledoc """
      If your transfer is returned, this will contain details of the return.

      ## Fields

        * `reason` - The reason for the transfer return.
        * `returned_at` - The time at which the transfer was returned.
        * `transaction_id` - The id of the transaction for the returned transfer.
      """

      defstruct [:reason, :returned_at, :transaction_id]

      @type t :: %__MODULE__{
              reason: String.t(),
              returned_at: DateTime.t(),
              transaction_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reason: raw["reason"],
          returned_at: Increase.Decode.datetime(raw["returned_at"]),
          transaction_id: raw["transaction_id"]
        }
      end
    end

    defstruct [
      :id,
      :acceptance,
      :account_id,
      :account_number_id,
      :addenda,
      :amount,
      :automatically_resolves_at,
      :created_at,
      :decline,
      :direction,
      :effective_date,
      :international_addenda,
      :notification_of_change,
      :originator_company_descriptive_date,
      :originator_company_discretionary_data,
      :originator_company_entry_description,
      :originator_company_id,
      :originator_company_name,
      :originator_routing_number,
      :receiver_id_number,
      :receiver_name,
      :settlement,
      :standard_entry_class_code,
      :status,
      :trace_number,
      :transfer_return,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            acceptance: Acceptance.t() | nil,
            account_id: String.t(),
            account_number_id: String.t(),
            addenda: Addenda.t() | nil,
            amount: integer(),
            automatically_resolves_at: DateTime.t(),
            created_at: DateTime.t(),
            decline: Decline.t() | nil,
            direction: String.t(),
            effective_date: Date.t(),
            international_addenda: InternationalAddenda.t() | nil,
            notification_of_change: NotificationOfChange.t() | nil,
            originator_company_descriptive_date: String.t() | nil,
            originator_company_discretionary_data: String.t() | nil,
            originator_company_entry_description: String.t(),
            originator_company_id: String.t(),
            originator_company_name: String.t(),
            originator_routing_number: String.t(),
            receiver_id_number: String.t() | nil,
            receiver_name: String.t() | nil,
            settlement: Settlement.t(),
            standard_entry_class_code: String.t(),
            status: String.t(),
            trace_number: String.t(),
            transfer_return: TransferReturn.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        acceptance: Increase.Decode.struct(raw["acceptance"], &Acceptance.decode/1),
        account_id: raw["account_id"],
        account_number_id: raw["account_number_id"],
        addenda: Increase.Decode.struct(raw["addenda"], &Addenda.decode/1),
        amount: raw["amount"],
        automatically_resolves_at: Increase.Decode.datetime(raw["automatically_resolves_at"]),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        decline: Increase.Decode.struct(raw["decline"], &Decline.decode/1),
        direction: raw["direction"],
        effective_date: Increase.Decode.date(raw["effective_date"]),
        international_addenda:
          Increase.Decode.struct(raw["international_addenda"], &InternationalAddenda.decode/1),
        notification_of_change:
          Increase.Decode.struct(raw["notification_of_change"], &NotificationOfChange.decode/1),
        originator_company_descriptive_date: raw["originator_company_descriptive_date"],
        originator_company_discretionary_data: raw["originator_company_discretionary_data"],
        originator_company_entry_description: raw["originator_company_entry_description"],
        originator_company_id: raw["originator_company_id"],
        originator_company_name: raw["originator_company_name"],
        originator_routing_number: raw["originator_routing_number"],
        receiver_id_number: raw["receiver_id_number"],
        receiver_name: raw["receiver_name"],
        settlement: Increase.Decode.struct(raw["settlement"], &Settlement.decode/1),
        standard_entry_class_code: raw["standard_entry_class_code"],
        status: raw["status"],
        trace_number: raw["trace_number"],
        transfer_return: Increase.Decode.struct(raw["transfer_return"], &TransferReturn.decode/1),
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve an Inbound ACH Transfer

  `GET /inbound_ach_transfers/{inbound_ach_transfer_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundACHTransfer.t()} | {:error, Increase.Error.t()}
  def retrieve(client, inbound_ach_transfer_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_ach_transfers/#{inbound_ach_transfer_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Inbound ACH Transfers

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  InboundACHTransfer{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /inbound_ach_transfers`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_ach_transfers"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &InboundACHTransfer.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Create a notification of change for an Inbound ACH Transfer

  `POST /inbound_ach_transfers/{inbound_ach_transfer_id}/create_notification_of_change`
  """
  @spec new_notification_of_change(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, InboundACHTransfer.t()} | {:error, Increase.Error.t()}
  def new_notification_of_change(client, inbound_ach_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_ach_transfers/#{inbound_ach_transfer_id}/create_notification_of_change"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, InboundACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Decline an Inbound ACH Transfer

  `POST /inbound_ach_transfers/{inbound_ach_transfer_id}/decline`
  """
  @spec decline(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, InboundACHTransfer.t()} | {:error, Increase.Error.t()}
  def decline(client, inbound_ach_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_ach_transfers/#{inbound_ach_transfer_id}/decline"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, InboundACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Return an Inbound ACH Transfer

  `POST /inbound_ach_transfers/{inbound_ach_transfer_id}/transfer_return`
  """
  @spec transfer_return(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, InboundACHTransfer.t()} | {:error, Increase.Error.t()}
  def transfer_return(client, inbound_ach_transfer_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_ach_transfers/#{inbound_ach_transfer_id}/transfer_return"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, InboundACHTransfer.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
