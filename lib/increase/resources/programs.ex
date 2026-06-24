defmodule Increase.Programs do
  @moduledoc """
  Programs determine the compliance and commercial terms of Accounts. By default,
  you have a Commercial Banking program for managing your own funds. If you are
  lending or managing funds on behalf of your customers, or otherwise engaged in
  regulated activity, we will work together to create additional Programs for you.

  See https://increase.com/documentation/api/programs for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule Program do
    @moduledoc """
    Programs determine the compliance and commercial terms of Accounts. By
    default, you have a Commercial Banking program for managing your own funds.
    If you are lending or managing funds on behalf of your customers, or
    otherwise engaged in regulated activity, we will work together to create
    additional Programs for you.

    ## Fields

      * `id` - The Program identifier.
      * `bank` - The Bank the Program is with.
      * `billing_account_id` - The Program billing account.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Program was created.
      * `default_digital_card_profile_id` - The default configuration for digital cards attached
        to this Program.
      * `interest_rate` - The Interest Rate currently being earned on the accounts in this
        program, as a string containing a decimal number. For example, a 1%
        interest rate would be represented as "0.01".
      * `lending` - The lending details for the program.
      * `name` - The name of the Program.
      * `type` - A constant representing the object's type. For this resource it will always be
        `program`.
      * `updated_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Program was last updated.
    """

    defmodule Lending do
      @moduledoc """
      The lending details for the program.

      ## Fields

        * `maximum_extendable_credit` - The maximum extendable credit of the program.
      """

      defstruct [:maximum_extendable_credit]

      @type t :: %__MODULE__{
              maximum_extendable_credit: integer()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          maximum_extendable_credit: raw["maximum_extendable_credit"]
        }
      end
    end

    defstruct [
      :id,
      :bank,
      :billing_account_id,
      :created_at,
      :default_digital_card_profile_id,
      :interest_rate,
      :lending,
      :name,
      :type,
      :updated_at
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            bank: String.t(),
            billing_account_id: String.t() | nil,
            created_at: DateTime.t(),
            default_digital_card_profile_id: String.t() | nil,
            interest_rate: String.t(),
            lending: Lending.t() | nil,
            name: String.t(),
            type: String.t(),
            updated_at: DateTime.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        bank: raw["bank"],
        billing_account_id: raw["billing_account_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        default_digital_card_profile_id: raw["default_digital_card_profile_id"],
        interest_rate: raw["interest_rate"],
        lending: Increase.Decode.struct(raw["lending"], &Lending.decode/1),
        name: raw["name"],
        type: raw["type"],
        updated_at: Increase.Decode.datetime(raw["updated_at"])
      }
    end
  end

  @doc """
  Retrieve a Program

  `GET /programs/{program_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Program.t()} | {:error, Increase.Error.t()}
  def retrieve(client, program_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/programs/#{program_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Program.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Programs

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  Program{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /programs`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/programs"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &Program.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
