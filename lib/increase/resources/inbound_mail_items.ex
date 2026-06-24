defmodule Increase.InboundMailItems do
  @moduledoc """
  Inbound Mail Items represent pieces of physical mail delivered to a Lockbox
  Address.

  See https://increase.com/documentation/api/inbound-mail-items for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule InboundMailItem do
    @moduledoc """
    Inbound Mail Items represent pieces of physical mail delivered to a Lockbox
    Address.

    ## Fields

      * `id` - The Inbound Mail Item identifier.
      * `checks` - The checks in the mail item.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Inbound Mail Item was created.
      * `file_id` - The identifier for the File containing the scanned contents of the mail
        item.
      * `lockbox_address_id` - The identifier for the Lockbox Address that received this mail
        item.
      * `lockbox_recipient_id` - The identifier for the Lockbox Recipient that received this
        mail item. For mail items that could not be routed to a Lockbox
        Recipient, this will be null.
      * `recipient_name` - The recipient name as written on the mail item.
      * `rejection_reason` - If the mail item has been rejected, why it was rejected.
      * `status` - If the mail item has been processed.
      * `type` - A constant representing the object's type. For this resource it will always be
        `inbound_mail_item`.
    """

    defmodule Check do
      @moduledoc """
      Inbound Mail Item Checks represent the checks in an Inbound Mail Item.

      ## Fields

        * `amount` - The amount of the check.
        * `back_file_id` - The identifier for the File containing the back of the check.
        * `check_deposit_id` - The identifier of the Check Deposit if this check was deposited.
        * `front_file_id` - The identifier for the File containing the front of the check.
        * `status` - The status of the Inbound Mail Item Check.
      """

      defstruct [:amount, :back_file_id, :check_deposit_id, :front_file_id, :status]

      @type t :: %__MODULE__{
              amount: integer(),
              back_file_id: String.t() | nil,
              check_deposit_id: String.t() | nil,
              front_file_id: String.t() | nil,
              status: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          amount: raw["amount"],
          back_file_id: raw["back_file_id"],
          check_deposit_id: raw["check_deposit_id"],
          front_file_id: raw["front_file_id"],
          status: raw["status"]
        }
      end
    end

    defstruct [
      :id,
      :checks,
      :created_at,
      :file_id,
      :lockbox_address_id,
      :lockbox_recipient_id,
      :recipient_name,
      :rejection_reason,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            checks: [Check.t()],
            created_at: DateTime.t(),
            file_id: String.t(),
            lockbox_address_id: String.t(),
            lockbox_recipient_id: String.t() | nil,
            recipient_name: String.t() | nil,
            rejection_reason: String.t() | nil,
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        checks: Increase.Decode.list(raw["checks"], &Check.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        file_id: raw["file_id"],
        lockbox_address_id: raw["lockbox_address_id"],
        lockbox_recipient_id: raw["lockbox_recipient_id"],
        recipient_name: raw["recipient_name"],
        rejection_reason: raw["rejection_reason"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve an Inbound Mail Item

  `GET /inbound_mail_items/{inbound_mail_item_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, InboundMailItem.t()} | {:error, Increase.Error.t()}
  def retrieve(client, inbound_mail_item_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_mail_items/#{inbound_mail_item_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, InboundMailItem.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Inbound Mail Items

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  InboundMailItem{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /inbound_mail_items`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_mail_items"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &InboundMailItem.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Action an Inbound Mail Item

  `POST /inbound_mail_items/{inbound_mail_item_id}/action`
  """
  @spec action(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, InboundMailItem.t()} | {:error, Increase.Error.t()}
  def action(client, inbound_mail_item_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/inbound_mail_items/#{inbound_mail_item_id}/action"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, InboundMailItem.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
