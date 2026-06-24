defmodule Increase.CardPayments do
  @moduledoc """
  Card Payments group together interactions related to a single card payment, such
  as an authorization and its corresponding settlement.

  See https://increase.com/documentation/api/card-payments for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CardPayment do
    @moduledoc """
    Card Payments group together interactions related to a single card payment,
    such as an authorization and its corresponding settlement.

    ## Fields

      * `id` - The Card Payment identifier.
      * `account_id` - The identifier for the Account the Transaction belongs to.
      * `card_id` - The Card identifier for this payment.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Card Payment was created.
      * `digital_wallet_token_id` - The Digital Wallet Token identifier for this payment.
      * `elements` - The interactions related to this card payment.
        A map keyed by `"category"`. Exactly one of the
        following keys is present, matching that discriminator's value:

          * `"card_authentication"`
          * `"card_authorization"`
          * `"card_authorization_expiration"`
          * `"card_balance_inquiry"`
          * `"card_decline"`
          * `"card_financial"`
          * `"card_fuel_confirmation"`
          * `"card_increment"`
          * `"card_refund"`
          * `"card_reversal"`
          * `"card_settlement"`
          * `"card_validation"`
          * `"other"`
      * `physical_card_id` - The Physical Card identifier for this payment.
      * `state` - The summarized state of this card payment.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_payment`.
    """

    defmodule State do
      @moduledoc """
      The summarized state of this card payment.

      ## Fields

        * `authorized_amount` - The total authorized amount in the minor unit of the
          transaction's currency. For dollars, for example, this is cents.
        * `fuel_confirmed_amount` - The total amount from fuel confirmations in the minor unit
          of the transaction's currency. For dollars, for example,
          this is cents.
        * `incremented_amount` - The total incrementally updated authorized amount in the minor
          unit of the transaction's currency. For dollars, for example,
          this is cents.
        * `refund_authorized_amount` - The total refund authorized amount in the minor unit of
          the transaction's currency. For dollars, for example,
          this is cents.
        * `refunded_amount` - The total refunded amount in the minor unit of the transaction's
          currency. For dollars, for example, this is cents.
        * `reversed_amount` - The total reversed amount in the minor unit of the transaction's
          currency. For dollars, for example, this is cents.
        * `settled_amount` - The total settled amount in the minor unit of the transaction's
          currency. For dollars, for example, this is cents.
      """

      defstruct [
        :authorized_amount,
        :fuel_confirmed_amount,
        :incremented_amount,
        :refund_authorized_amount,
        :refunded_amount,
        :reversed_amount,
        :settled_amount
      ]

      @type t :: %__MODULE__{
              authorized_amount: integer(),
              fuel_confirmed_amount: integer(),
              incremented_amount: integer(),
              refund_authorized_amount: integer(),
              refunded_amount: integer(),
              reversed_amount: integer(),
              settled_amount: integer()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          authorized_amount: raw["authorized_amount"],
          fuel_confirmed_amount: raw["fuel_confirmed_amount"],
          incremented_amount: raw["incremented_amount"],
          refund_authorized_amount: raw["refund_authorized_amount"],
          refunded_amount: raw["refunded_amount"],
          reversed_amount: raw["reversed_amount"],
          settled_amount: raw["settled_amount"]
        }
      end
    end

    defstruct [
      :id,
      :account_id,
      :card_id,
      :created_at,
      :digital_wallet_token_id,
      :elements,
      :physical_card_id,
      :state,
      :type
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: String.t(),
            card_id: String.t(),
            created_at: DateTime.t(),
            digital_wallet_token_id: String.t() | nil,
            elements: [map()],
            physical_card_id: String.t() | nil,
            state: State.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_id: raw["account_id"],
        card_id: raw["card_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        digital_wallet_token_id: raw["digital_wallet_token_id"],
        elements: raw["elements"],
        physical_card_id: raw["physical_card_id"],
        state: Increase.Decode.struct(raw["state"], &State.decode/1),
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve a Card Payment

  `GET /card_payments/{card_payment_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardPayment.t()} | {:error, Increase.Error.t()}
  def retrieve(client, card_payment_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_payments/#{card_payment_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardPayment.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Card Payments

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CardPayment{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /card_payments`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_payments"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CardPayment.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
