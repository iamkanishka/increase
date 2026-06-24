defmodule Increase.LockboxRecipients do
  @moduledoc """
  Lockbox Recipients represent an inbox at a Lockbox Address. Checks received for
  a Lockbox Recipient are deposited into its associated Account.

  See https://increase.com/documentation/api/lockbox-recipients for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule LockboxRecipient do
    @moduledoc """
    Lockbox Recipients represent an inbox at a Lockbox Address. Checks received
    for a Lockbox Recipient are deposited into its associated Account.

    ## Fields

      * `id` - The Lockbox Recipient identifier.
      * `account_id` - The identifier for the Account that checks sent to this Lockbox Recipient
        will be deposited into.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Lockbox Recipient was created.
      * `description` - The description of the Lockbox Recipient.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `lockbox_address_id` - The identifier for the Lockbox Address where this Lockbox
        Recipient may receive physical mail.
      * `mail_stop_code` - The mail stop code uniquely identifying this Lockbox Recipient at its
        Lockbox Address. It should be included in the mailing address
        intended for this Lockbox Recipient.
      * `recipient_name` - The name of the Lockbox Recipient.
      * `status` - The status of the Lockbox Recipient.
      * `type` - A constant representing the object's type. For this resource it will always be
        `lockbox_recipient`.
    """

    defstruct [
      :id,
      :account_id,
      :created_at,
      :description,
      :idempotency_key,
      :lockbox_address_id,
      :mail_stop_code,
      :recipient_name,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            created_at: DateTime.t(),
            description: String.t() | nil,
            idempotency_key: String.t() | nil,
            lockbox_address_id: String.t(),
            mail_stop_code: String.t(),
            recipient_name: String.t() | nil,
            status: String.t() | nil,
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        description: raw["description"],
        idempotency_key: raw["idempotency_key"],
        lockbox_address_id: raw["lockbox_address_id"],
        mail_stop_code: raw["mail_stop_code"],
        recipient_name: raw["recipient_name"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Create a Lockbox Recipient

  `POST /lockbox_recipients`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, LockboxRecipient.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_recipients"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, LockboxRecipient.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Lockbox Recipient

  `GET /lockbox_recipients/{lockbox_recipient_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, LockboxRecipient.t()} | {:error, Increase.Error.t()}
  def retrieve(client, lockbox_recipient_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_recipients/#{lockbox_recipient_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, LockboxRecipient.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update a Lockbox Recipient

  `PATCH /lockbox_recipients/{lockbox_recipient_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, LockboxRecipient.t()} | {:error, Increase.Error.t()}
  def update(client, lockbox_recipient_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_recipients/#{lockbox_recipient_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, LockboxRecipient.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Lockbox Recipients

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  LockboxRecipient{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /lockbox_recipients`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/lockbox_recipients"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &LockboxRecipient.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
