defmodule Increase.IntrafiAccountEnrollments do
  @moduledoc """
  IntraFi is a
  [network of financial institutions](https://www.intrafi.com/network-banks) that
  allows Increase users to sweep funds to multiple banks. This enables accounts to
  become eligible for additional Federal Deposit Insurance Corporation (FDIC)
  insurance. An IntraFi Account Enrollment object represents the status of an
  account in the network. Sweeping an account to IntraFi doesn't affect funds
  availability.

  See https://increase.com/documentation/api/intrafi-account-enrollments for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule IntrafiAccountEnrollment do
    @moduledoc """
    IntraFi is a [network of financial
    institutions](https://www.intrafi.com/network-banks) that allows Increase
    users to sweep funds to multiple banks. This enables accounts to become
    eligible for additional Federal Deposit Insurance Corporation (FDIC)
    insurance. An IntraFi Account Enrollment object represents the status of an
    account in the network. Sweeping an account to IntraFi doesn't affect funds
    availability.

    ## Fields

      * `id` - The identifier of this enrollment at IntraFi.
      * `account_id` - The identifier of the Increase Account being swept into the network.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the enrollment was created.
      * `email_address` - The contact email for the account owner, to be shared with IntraFi.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `intrafi_id` - The identifier of the account in IntraFi's system. This identifier will
        be printed on any IntraFi statements or documents.
      * `status` - The status of the account in the network. An account takes about one business
        day to go from `pending_enrolling` to `enrolled`.
      * `type` - A constant representing the object's type. For this resource it will always be
        `intrafi_account_enrollment`.
    """

    defstruct [
      :id,
      :account_id,
      :created_at,
      :email_address,
      :idempotency_key,
      :intrafi_id,
      :status,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            created_at: DateTime.t(),
            email_address: String.t() | nil,
            idempotency_key: String.t() | nil,
            intrafi_id: String.t(),
            status: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        email_address: raw["email_address"],
        idempotency_key: raw["idempotency_key"],
        intrafi_id: raw["intrafi_id"],
        status: raw["status"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Enroll an account in the IntraFi deposit sweep network

  `POST /intrafi_account_enrollments`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, IntrafiAccountEnrollment.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_account_enrollments"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, IntrafiAccountEnrollment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Get an IntraFi Account Enrollment

  `GET /intrafi_account_enrollments/{intrafi_account_enrollment_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, IntrafiAccountEnrollment.t()} | {:error, Increase.Error.t()}
  def retrieve(client, intrafi_account_enrollment_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_account_enrollments/#{intrafi_account_enrollment_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, IntrafiAccountEnrollment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List IntraFi Account Enrollments

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  IntrafiAccountEnrollment{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /intrafi_account_enrollments`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_account_enrollments"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &IntrafiAccountEnrollment.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Unenroll an account from IntraFi

  `POST /intrafi_account_enrollments/{intrafi_account_enrollment_id}/unenroll`
  """
  @spec unenroll(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, IntrafiAccountEnrollment.t()} | {:error, Increase.Error.t()}
  def unenroll(client, intrafi_account_enrollment_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/intrafi_account_enrollments/#{intrafi_account_enrollment_id}/unenroll"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, IntrafiAccountEnrollment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
