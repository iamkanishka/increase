defmodule Increase.ACHPrenotifications do
  @moduledoc """
  ACH Prenotifications are one way you can verify account and routing numbers by
  Automated Clearing House (ACH).

  See https://increase.com/documentation/api/ach-prenotifications for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule ACHPrenotification do
    @moduledoc """
    ACH Prenotifications are one way you can verify account and routing numbers
    by Automated Clearing House (ACH).

    ## Fields

      * `id` - The ACH Prenotification's identifier.
      * `account_id` - The account that sent the ACH Prenotification.
      * `account_number` - The destination account number.
      * `addendum` - Additional information for the recipient.
      * `company_descriptive_date` - The description of the date of the notification.
      * `company_discretionary_data` - Optional data associated with the notification.
      * `company_entry_description` - The description of the notification.
      * `company_name` - The name by which you know the company.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the prenotification was created.
      * `credit_debit_indicator` - If the notification is for a future credit or debit.
      * `effective_date` - The effective date in [ISO
        8601](https://en.wikipedia.org/wiki/ISO_8601) format.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `individual_id` - Your identifier for the recipient.
      * `individual_name` - The name of the recipient. This value is informational and not
        verified by the recipient's bank.
      * `notifications_of_change` - If the receiving bank notifies that future transfers should
        use different details, this will contain those details.
      * `prenotification_return` - If your prenotification is returned, this will contain
        details of the return.
      * `routing_number` - The American Bankers' Association (ABA) Routing Transit Number (RTN).
      * `standard_entry_class_code` - The [Standard Entry Class (SEC)
        code] to
        use for the ACH Prenotification.
      * `status` - The lifecycle status of the ACH Prenotification.
      * `type` - A constant representing the object's type. For this resource it will always be
        `ach_prenotification`.
    """

    defmodule NotificationsOfChange do
      @moduledoc """
      The `ACHPrenotificationNotificationsOfChange` object.

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

    defmodule PrenotificationReturn do
      @moduledoc """
      If your prenotification is returned, this will contain details of the
      return.

      ## Fields

        * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the Prenotification was returned.
        * `return_reason_code` - Why the Prenotification was returned.
      """

      defstruct [:created_at, :return_reason_code]

      @type t :: %__MODULE__{
              created_at: DateTime.t(),
              return_reason_code: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          created_at: Increase.Decode.datetime(raw["created_at"]),
          return_reason_code: raw["return_reason_code"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :account_number,
      :addendum,
      :company_descriptive_date,
      :company_discretionary_data,
      :company_entry_description,
      :company_name,
      :created_at,
      :credit_debit_indicator,
      :effective_date,
      :idempotency_key,
      :individual_id,
      :individual_name,
      :notifications_of_change,
      :prenotification_return,
      :routing_number,
      :standard_entry_class_code,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t() | nil,
            account_number: String.t(),
            addendum: String.t() | nil,
            company_descriptive_date: String.t() | nil,
            company_discretionary_data: String.t() | nil,
            company_entry_description: String.t() | nil,
            company_name: String.t() | nil,
            created_at: DateTime.t(),
            credit_debit_indicator: String.t() | nil,
            effective_date: DateTime.t() | nil,
            idempotency_key: String.t() | nil,
            individual_id: String.t() | nil,
            individual_name: String.t() | nil,
            notifications_of_change: [NotificationsOfChange.t()],
            prenotification_return: PrenotificationReturn.t() | nil,
            routing_number: String.t(),
            standard_entry_class_code: String.t() | nil,
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        account_number: raw["account_number"],
        addendum: raw["addendum"],
        company_descriptive_date: raw["company_descriptive_date"],
        company_discretionary_data: raw["company_discretionary_data"],
        company_entry_description: raw["company_entry_description"],
        company_name: raw["company_name"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        credit_debit_indicator: raw["credit_debit_indicator"],
        effective_date: Increase.Decode.datetime(raw["effective_date"]),
        idempotency_key: raw["idempotency_key"],
        individual_id: raw["individual_id"],
        individual_name: raw["individual_name"],
        notifications_of_change:
          Increase.Decode.list(raw["notifications_of_change"], &NotificationsOfChange.decode/1),
        prenotification_return:
          Increase.Decode.struct(raw["prenotification_return"], &PrenotificationReturn.decode/1),
        routing_number: raw["routing_number"],
        standard_entry_class_code: raw["standard_entry_class_code"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create an ACH Prenotification

  `POST /ach_prenotifications`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, ACHPrenotification.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_prenotifications"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, ACHPrenotification.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an ACH Prenotification

  `GET /ach_prenotifications/{ach_prenotification_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, ACHPrenotification.t()} | {:error, Increase.Error.t()}
  def retrieve(client, ach_prenotification_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_prenotifications/#{ach_prenotification_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, ACHPrenotification.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List ACH Prenotifications

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  ACHPrenotification{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /ach_prenotifications`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/ach_prenotifications"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &ACHPrenotification.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
