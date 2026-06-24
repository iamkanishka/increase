defmodule Increase.CardPurchaseSupplements do
  @moduledoc """
  Additional information about a card purchase (e.g., settlement or refund), such
  as level 3 line item data.

  See https://increase.com/documentation/api/card-purchase-supplements for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CardPurchaseSupplement do
    @moduledoc """
    Additional information about a card purchase (e.g., settlement or refund),
    such as level 3 line item data.

    ## Fields

      * `id` - The Card Purchase Supplement identifier.
      * `card_payment_id` - The ID of the Card Payment this transaction belongs to.
      * `invoice` - Invoice-level information about the payment.
      * `line_items` - Line item information, such as individual products purchased.
      * `shipping` - Shipping information for the purchase.
      * `transaction_id` - The ID of the transaction.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_purchase_supplement`.
    """

    defmodule Invoice do
      @moduledoc """
      Invoice-level information about the payment.

      ## Fields

        * `discount_amount` - Discount given to cardholder.
        * `discount_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for
          the discount.
        * `discount_treatment_code` - Indicates how the merchant applied the discount.
        * `duty_tax_amount` - Amount of duty taxes.
        * `duty_tax_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for
          the duty tax.
        * `order_date` - Date the order was taken.
        * `shipping_amount` - The shipping cost.
        * `shipping_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for
          the shipping cost.
        * `shipping_destination_country_code` - Country code of the shipping destination.
        * `shipping_destination_postal_code` - Postal code of the shipping destination.
        * `shipping_source_postal_code` - Postal code of the location being shipped from.
        * `shipping_tax_amount` - Taxes paid for freight and shipping.
        * `shipping_tax_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code
          for the shipping tax.
        * `shipping_tax_rate` - Tax rate for freight and shipping.
        * `tax_treatments` - Indicates how the merchant applied taxes.
        * `unique_value_added_tax_invoice_reference` - Value added tax invoice reference number.
      """

      defstruct [
        :discount_amount,
        :discount_currency,
        :discount_treatment_code,
        :duty_tax_amount,
        :duty_tax_currency,
        :order_date,
        :shipping_amount,
        :shipping_currency,
        :shipping_destination_country_code,
        :shipping_destination_postal_code,
        :shipping_source_postal_code,
        :shipping_tax_amount,
        :shipping_tax_currency,
        :shipping_tax_rate,
        :tax_treatments,
        :unique_value_added_tax_invoice_reference
      ]

      @type t :: %__MODULE__{
              discount_amount: integer() | nil,
              discount_currency: String.t() | nil,
              discount_treatment_code: String.t() | nil,
              duty_tax_amount: integer() | nil,
              duty_tax_currency: String.t() | nil,
              order_date: Date.t() | nil,
              shipping_amount: integer() | nil,
              shipping_currency: String.t() | nil,
              shipping_destination_country_code: String.t() | nil,
              shipping_destination_postal_code: String.t() | nil,
              shipping_source_postal_code: String.t() | nil,
              shipping_tax_amount: integer() | nil,
              shipping_tax_currency: String.t() | nil,
              shipping_tax_rate: String.t() | nil,
              tax_treatments: String.t() | nil,
              unique_value_added_tax_invoice_reference: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          discount_amount: raw["discount_amount"],
          discount_currency: raw["discount_currency"],
          discount_treatment_code: raw["discount_treatment_code"],
          duty_tax_amount: raw["duty_tax_amount"],
          duty_tax_currency: raw["duty_tax_currency"],
          order_date: Increase.Decode.date(raw["order_date"]),
          shipping_amount: raw["shipping_amount"],
          shipping_currency: raw["shipping_currency"],
          shipping_destination_country_code: raw["shipping_destination_country_code"],
          shipping_destination_postal_code: raw["shipping_destination_postal_code"],
          shipping_source_postal_code: raw["shipping_source_postal_code"],
          shipping_tax_amount: raw["shipping_tax_amount"],
          shipping_tax_currency: raw["shipping_tax_currency"],
          shipping_tax_rate: raw["shipping_tax_rate"],
          tax_treatments: raw["tax_treatments"],
          unique_value_added_tax_invoice_reference:
            raw["unique_value_added_tax_invoice_reference"]
        }
      end
    end

    defmodule LineItem do
      @moduledoc """
      The `CardPurchaseSupplementLineItem` object.

      ## Fields

        * `id` - The Card Purchase Supplement Line Item identifier.
        * `detail_indicator` - Indicates the type of line item.
        * `discount_amount` - Discount amount for this specific line item.
        * `discount_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for
          the discount.
        * `discount_treatment_code` - Indicates how the merchant applied the discount for this
          specific line item.
        * `item_commodity_code` - Code used to categorize the purchase item.
        * `item_descriptor` - Description of the purchase item.
        * `item_quantity` - The number of units of the product being purchased.
        * `product_code` - Code used to categorize the product being purchased.
        * `sales_tax_amount` - Sales tax amount for this line item.
        * `sales_tax_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for
          the sales tax assessed.
        * `sales_tax_rate` - Sales tax rate for this line item.
        * `total_amount` - Total amount of all line items.
        * `total_amount_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code
          for the total amount.
        * `unit_cost` - Cost of line item per unit of measure, in major units.
        * `unit_cost_currency` - The [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) code for
          the unit cost.
        * `unit_of_measure_code` - Code indicating unit of measure (gallons, etc.).
      """

      defstruct [
        :id,
        :detail_indicator,
        :discount_amount,
        :discount_currency,
        :discount_treatment_code,
        :item_commodity_code,
        :item_descriptor,
        :item_quantity,
        :product_code,
        :sales_tax_amount,
        :sales_tax_currency,
        :sales_tax_rate,
        :total_amount,
        :total_amount_currency,
        :unit_cost,
        :unit_cost_currency,
        :unit_of_measure_code
      ]

      @type t :: %__MODULE__{
              id: String.t(),
              detail_indicator: String.t() | nil,
              discount_amount: integer() | nil,
              discount_currency: String.t() | nil,
              discount_treatment_code: String.t() | nil,
              item_commodity_code: String.t() | nil,
              item_descriptor: String.t() | nil,
              item_quantity: String.t() | nil,
              product_code: String.t() | nil,
              sales_tax_amount: integer() | nil,
              sales_tax_currency: String.t() | nil,
              sales_tax_rate: String.t() | nil,
              total_amount: integer() | nil,
              total_amount_currency: String.t() | nil,
              unit_cost: String.t() | nil,
              unit_cost_currency: String.t() | nil,
              unit_of_measure_code: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          id: raw["id"],
          detail_indicator: raw["detail_indicator"],
          discount_amount: raw["discount_amount"],
          discount_currency: raw["discount_currency"],
          discount_treatment_code: raw["discount_treatment_code"],
          item_commodity_code: raw["item_commodity_code"],
          item_descriptor: raw["item_descriptor"],
          item_quantity: raw["item_quantity"],
          product_code: raw["product_code"],
          sales_tax_amount: raw["sales_tax_amount"],
          sales_tax_currency: raw["sales_tax_currency"],
          sales_tax_rate: raw["sales_tax_rate"],
          total_amount: raw["total_amount"],
          total_amount_currency: raw["total_amount_currency"],
          unit_cost: raw["unit_cost"],
          unit_cost_currency: raw["unit_cost_currency"],
          unit_of_measure_code: raw["unit_of_measure_code"]
        }
      end
    end

    defmodule Shipping do
      @moduledoc """
      Shipping information for the purchase.

      ## Fields

        * `customer_reference_number` - The customer reference number.
        * `destination_address` - Address of the destination.
        * `destination_country_code` - Country code of the destination.
        * `destination_postal_code` - Postal code of the destination.
        * `destination_receiver_name` - Name of the receiver at the destination.
        * `discount_amount` - Discount amount for the shipment.
        * `net_amount` - Net shipping amount.
        * `number_of_packages` - Number of packages shipped.
        * `origin_address` - Address of the origin.
        * `origin_country_code` - Country code of the origin.
        * `origin_postal_code` - Postal code of the origin.
        * `origin_sender_name` - Name of the sender at the origin.
        * `pick_up_date` - Date the shipment should be picked up.
        * `service_description` - Description of the shipping service.
        * `service_level_code` - Service level code for the shipment.
        * `shipping_courier_name` - Name of the shipping courier.
        * `tax_amount` - Tax amount for the shipment.
        * `tracking_number` - Tracking number for the shipment.
        * `unit_of_measure` - Unit of measure for the shipment weight.
        * `weight` - Weight of the shipment.
      """

      defstruct [
        :customer_reference_number,
        :destination_address,
        :destination_country_code,
        :destination_postal_code,
        :destination_receiver_name,
        :discount_amount,
        :net_amount,
        :number_of_packages,
        :origin_address,
        :origin_country_code,
        :origin_postal_code,
        :origin_sender_name,
        :pick_up_date,
        :service_description,
        :service_level_code,
        :shipping_courier_name,
        :tax_amount,
        :tracking_number,
        :unit_of_measure,
        :weight
      ]

      @type t :: %__MODULE__{
              customer_reference_number: String.t() | nil,
              destination_address: String.t() | nil,
              destination_country_code: String.t() | nil,
              destination_postal_code: String.t() | nil,
              destination_receiver_name: String.t() | nil,
              discount_amount: integer() | nil,
              net_amount: integer() | nil,
              number_of_packages: integer() | nil,
              origin_address: String.t() | nil,
              origin_country_code: String.t() | nil,
              origin_postal_code: String.t() | nil,
              origin_sender_name: String.t() | nil,
              pick_up_date: Date.t() | nil,
              service_description: String.t() | nil,
              service_level_code: String.t() | nil,
              shipping_courier_name: String.t() | nil,
              tax_amount: integer() | nil,
              tracking_number: String.t() | nil,
              unit_of_measure: String.t() | nil,
              weight: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          customer_reference_number: raw["customer_reference_number"],
          destination_address: raw["destination_address"],
          destination_country_code: raw["destination_country_code"],
          destination_postal_code: raw["destination_postal_code"],
          destination_receiver_name: raw["destination_receiver_name"],
          discount_amount: raw["discount_amount"],
          net_amount: raw["net_amount"],
          number_of_packages: raw["number_of_packages"],
          origin_address: raw["origin_address"],
          origin_country_code: raw["origin_country_code"],
          origin_postal_code: raw["origin_postal_code"],
          origin_sender_name: raw["origin_sender_name"],
          pick_up_date: Increase.Decode.date(raw["pick_up_date"]),
          service_description: raw["service_description"],
          service_level_code: raw["service_level_code"],
          shipping_courier_name: raw["shipping_courier_name"],
          tax_amount: raw["tax_amount"],
          tracking_number: raw["tracking_number"],
          unit_of_measure: raw["unit_of_measure"],
          weight: raw["weight"]
        }
      end
    end

    defstruct [:id, :card_payment_id, :invoice, :line_items, :shipping, :transaction_id, :type]

    @type t :: %__MODULE__{
            id: String.t(),
            card_payment_id: String.t() | nil,
            invoice: Invoice.t() | nil,
            line_items: [LineItem.t()] | nil,
            shipping: Shipping.t() | nil,
            transaction_id: String.t(),
            type: String.t()
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        card_payment_id: raw["card_payment_id"],
        invoice: Increase.Decode.struct(raw["invoice"], &Invoice.decode/1),
        line_items: Increase.Decode.list(raw["line_items"], &LineItem.decode/1),
        shipping: Increase.Decode.struct(raw["shipping"], &Shipping.decode/1),
        transaction_id: raw["transaction_id"],
        type: raw["type"]
      }
    end
  end

  @doc """
  Retrieve a Card Purchase Supplement

  `GET /card_purchase_supplements/{card_purchase_supplement_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardPurchaseSupplement.t()} | {:error, Increase.Error.t()}
  def retrieve(client, card_purchase_supplement_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_purchase_supplements/#{card_purchase_supplement_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardPurchaseSupplement.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Card Purchase Supplements

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CardPurchaseSupplement{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /card_purchase_supplements`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_purchase_supplements"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CardPurchaseSupplement.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
