defmodule Increase.Exports do
  @moduledoc """
  Exports are generated files. Some exports can contain a lot of data, like a CSV
  of your transactions. Others can be a single document, like a tax form. Since
  they can take a while, they are generated asynchronously. We send a webhook when
  they are ready. For more information, please read our
  [Exports documentation](https://increase.com/documentation/exports).

  See https://increase.com/documentation/api/exports for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule Export do
    @moduledoc """
    Exports are generated files. Some exports can contain a lot of data, like a
    CSV of your transactions. Others can be a single document, like a tax form.
    Since they can take a while, they are generated asynchronously. We send a
    webhook when they are ready. For more information, please read our [Exports
    documentation](https://increase.com/documentation/exports).

    ## Fields

      * `id` - The Export identifier.
      * `account_statement_bai2` - Details of the account statement BAI2 export. This field will
        be present when the `category` is equal to
        `account_statement_bai2`.
      * `account_statement_ofx` - Details of the account statement OFX export. This field will
        be present when the `category` is equal to
        `account_statement_ofx`.
      * `account_verification_letter` - Details of the account verification letter export. This
        field will be present when the `category` is equal to
        `account_verification_letter`.
      * `balance_csv` - Details of the balance CSV export. This field will be present when the
        `category` is equal to `balance_csv`.
      * `bookkeeping_account_balance_csv` - Details of the bookkeeping account balance CSV
        export. This field will be present when the
        `category` is equal to
        `bookkeeping_account_balance_csv`.
      * `category` - The category of the Export. We may add additional possible values for this
        enum over time; your application should be able to handle that gracefully.
      * `created_at` - The time the Export was created.
      * `daily_account_balance_csv` - Details of the daily account balance CSV export. This
        field will be present when the `category` is equal to
        `daily_account_balance_csv`.
      * `dashboard_table_csv` - Details of the dashboard table CSV export. This field will be
        present when the `category` is equal to `dashboard_table_csv`.
      * `entity_csv` - Details of the entity CSV export. This field will be present when the
        `category` is equal to `entity_csv`.
      * `fee_csv` - Details of the fee CSV export. This field will be present when the
        `category` is equal to `fee_csv`.
      * `form_1099_int` - Details of the Form 1099-INT export. This field will be present when
        the `category` is equal to `form_1099_int`.
      * `form_1099_misc` - Details of the Form 1099-MISC export. This field will be present when
        the `category` is equal to `form_1099_misc`.
      * `funding_instructions` - Details of the funding instructions export. This field will be
        present when the `category` is equal to `funding_instructions`.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `result` - The result of the Export. This will be present when the Export's status
        transitions to `complete`.
      * `status` - The status of the Export.
      * `transaction_csv` - Details of the transaction CSV export. This field will be present
        when the `category` is equal to `transaction_csv`.
      * `type` - A constant representing the object's type. For this resource it will always be
        `export`.
      * `vendor_csv` - Details of the vendor CSV export. This field will be present when the
        `category` is equal to `vendor_csv`.
      * `voided_check` - Details of the voided check export. This field will be present when the
        `category` is equal to `voided_check`.
    """

    defmodule AccountStatementBai2 do
      @moduledoc """
      Details of the account statement BAI2 export. This field will be present
      when the `category` is equal to `account_statement_bai2`.

      ## Fields

        * `account_id` - Filter results by Account.
        * `effective_date` - The date for which to retrieve the balance.
        * `program_id` - Filter results by Program.
      """

      defstruct [:account_id, :effective_date, :program_id]

      @type t :: %__MODULE__{
              account_id: String.t() | nil,
              effective_date: Date.t() | nil,
              program_id: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          effective_date: Increase.Decode.date(raw["effective_date"]),
          program_id: raw["program_id"]
        }
      end
    end

    defmodule AccountStatementOfx do
      @moduledoc """
      Details of the account statement OFX export. This field will be present when
      the `category` is equal to `account_statement_ofx`.

      ## Fields

        * `account_id` - The Account to create a statement for.
        * `created_at` - Filter transactions by their created date.
      """

      defmodule CreatedAt do
        @moduledoc """
        Filter transactions by their created date.

        ## Fields

          * `before` - Filter results to transactions created before this time.
          * `on_or_after` - Filter results to transactions created on or after this time.
        """

        defstruct [:before, :on_or_after]

        @type t :: %__MODULE__{
                before: DateTime.t() | nil,
                on_or_after: DateTime.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            before: Increase.Decode.datetime(raw["before"]),
            on_or_after: Increase.Decode.datetime(raw["on_or_after"])
          }
        end
      end

      defstruct [:account_id, :created_at]

      @type t :: %__MODULE__{
              account_id: String.t(),
              created_at: CreatedAt.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          created_at: Increase.Decode.struct(raw["created_at"], &CreatedAt.decode/1)
        }
      end
    end

    defmodule AccountVerificationLetter do
      @moduledoc """
      Details of the account verification letter export. This field will be
      present when the `category` is equal to `account_verification_letter`.

      ## Fields

        * `account_number_id` - The Account Number to create a letter for.
        * `balance_date` - The date of the balance to include in the letter.
      """

      defstruct [:account_number_id, :balance_date]

      @type t :: %__MODULE__{
              account_number_id: String.t(),
              balance_date: Date.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_number_id: raw["account_number_id"],
          balance_date: Increase.Decode.date(raw["balance_date"])
        }
      end
    end

    defmodule BalanceCsv do
      @moduledoc """
      Details of the balance CSV export. This field will be present when the
      `category` is equal to `balance_csv`.

      ## Fields

        * `account_id` - Filter results by Account.
        * `created_at` - Filter balances by their created date.
      """

      defmodule CreatedAt do
        @moduledoc """
        Filter balances by their created date.

        ## Fields

          * `after` - Filter balances created after this time.
          * `before` - Filter balances created before this time.
        """

        defstruct [:after, :before]

        @type t :: %__MODULE__{
                after: DateTime.t() | nil,
                before: DateTime.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            after: Increase.Decode.datetime(raw["after"]),
            before: Increase.Decode.datetime(raw["before"])
          }
        end
      end

      defstruct [:account_id, :created_at]

      @type t :: %__MODULE__{
              account_id: String.t() | nil,
              created_at: CreatedAt.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          created_at: Increase.Decode.struct(raw["created_at"], &CreatedAt.decode/1)
        }
      end
    end

    defmodule BookkeepingAccountBalanceCsv do
      @moduledoc """
      Details of the bookkeeping account balance CSV export. This field will be
      present when the `category` is equal to `bookkeeping_account_balance_csv`.

      ## Fields

        * `bookkeeping_account_id` - Filter results by Bookkeeping Account.
        * `on_or_after_date` - Filter balances to those on or after this date.
        * `on_or_before_date` - Filter balances to those on or before this date.
      """

      defstruct [:bookkeeping_account_id, :on_or_after_date, :on_or_before_date]

      @type t :: %__MODULE__{
              bookkeeping_account_id: String.t() | nil,
              on_or_after_date: Date.t() | nil,
              on_or_before_date: Date.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          bookkeeping_account_id: raw["bookkeeping_account_id"],
          on_or_after_date: Increase.Decode.date(raw["on_or_after_date"]),
          on_or_before_date: Increase.Decode.date(raw["on_or_before_date"])
        }
      end
    end

    defmodule DailyAccountBalanceCsv do
      @moduledoc """
      Details of the daily account balance CSV export. This field will be present
      when the `category` is equal to `daily_account_balance_csv`.

      ## Fields

        * `account_id` - Filter results by Account.
        * `on_or_after_date` - Filter balances on or after this date.
        * `on_or_before_date` - Filter balances on or before this date.
      """

      defstruct [:account_id, :on_or_after_date, :on_or_before_date]

      @type t :: %__MODULE__{
              account_id: String.t() | nil,
              on_or_after_date: Date.t() | nil,
              on_or_before_date: Date.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          on_or_after_date: Increase.Decode.date(raw["on_or_after_date"]),
          on_or_before_date: Increase.Decode.date(raw["on_or_before_date"])
        }
      end
    end

    defmodule DashboardTableCsv do
      @moduledoc """
      Details of the dashboard table CSV export. This field will be present when
      the `category` is equal to `dashboard_table_csv`.

      ## Fields

      """

      defstruct []

      @type t :: %__MODULE__{}

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{}
      end
    end

    defmodule EntityCsv do
      @moduledoc """
      Details of the entity CSV export. This field will be present when the
      `category` is equal to `entity_csv`.

      ## Fields

      """

      defstruct []

      @type t :: %__MODULE__{}

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{}
      end
    end

    defmodule FeeCsv do
      @moduledoc """
      Details of the fee CSV export. This field will be present when the
      `category` is equal to `fee_csv`.

      ## Fields

        * `created_at` - Filter fees by their created date. The time range must not include any
          fees that are part of an open fee statement.
      """

      defmodule CreatedAt do
        @moduledoc """
        Filter fees by their created date. The time range must not include any fees
        that are part of an open fee statement.

        ## Fields

          * `after` - Filter fees created after this time.
          * `before` - Filter fees created before this time.
          * `on_or_after` - Filter fees created on or after this time.
          * `on_or_before` - Filter fees created on or before this time.
        """

        defstruct [:after, :before, :on_or_after, :on_or_before]

        @type t :: %__MODULE__{
                after: DateTime.t() | nil,
                before: DateTime.t() | nil,
                on_or_after: DateTime.t() | nil,
                on_or_before: DateTime.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            after: Increase.Decode.datetime(raw["after"]),
            before: Increase.Decode.datetime(raw["before"]),
            on_or_after: Increase.Decode.datetime(raw["on_or_after"]),
            on_or_before: Increase.Decode.datetime(raw["on_or_before"])
          }
        end
      end

      defstruct [:created_at]

      @type t :: %__MODULE__{
              created_at: CreatedAt.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          created_at: Increase.Decode.struct(raw["created_at"], &CreatedAt.decode/1)
        }
      end
    end

    defmodule Form1099Int do
      @moduledoc """
      Details of the Form 1099-INT export. This field will be present when the
      `category` is equal to `form_1099_int`.

      ## Fields

        * `account_id` - The Account the tax form is for.
        * `corrected` - Whether the tax form is a corrected form.
        * `description` - A description of the tax form.
        * `year` - The tax year for the tax form.
      """

      defstruct [:account_id, :corrected, :description, :year]

      @type t :: %__MODULE__{
              account_id: String.t(),
              corrected: boolean(),
              description: String.t(),
              year: integer()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          corrected: raw["corrected"],
          description: raw["description"],
          year: raw["year"]
        }
      end
    end

    defmodule Form1099Misc do
      @moduledoc """
      Details of the Form 1099-MISC export. This field will be present when the
      `category` is equal to `form_1099_misc`.

      ## Fields

        * `account_id` - The Account the tax form is for.
        * `corrected` - Whether the tax form is a corrected form.
        * `year` - The tax year for the tax form.
      """

      defstruct [:account_id, :corrected, :year]

      @type t :: %__MODULE__{
              account_id: String.t(),
              corrected: boolean(),
              year: integer()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          corrected: raw["corrected"],
          year: raw["year"]
        }
      end
    end

    defmodule FundingInstructions do
      @moduledoc """
      Details of the funding instructions export. This field will be present when
      the `category` is equal to `funding_instructions`.

      ## Fields

        * `account_number_id` - The Account Number to create funding instructions for.
      """

      defstruct [:account_number_id]

      @type t :: %__MODULE__{
              account_number_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_number_id: raw["account_number_id"]
        }
      end
    end

    defmodule Result do
      @moduledoc """
      The result of the Export. This will be present when the Export's status
      transitions to `complete`.

      ## Fields

        * `file_id` - The File containing the contents of the Export.
      """

      defstruct [:file_id]

      @type t :: %__MODULE__{
              file_id: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          file_id: raw["file_id"]
        }
      end
    end

    defmodule TransactionCsv do
      @moduledoc """
      Details of the transaction CSV export. This field will be present when the
      `category` is equal to `transaction_csv`.

      ## Fields

        * `account_id` - Filter results by Account.
        * `created_at` - Filter transactions by their created date.
      """

      defmodule CreatedAt do
        @moduledoc """
        Filter transactions by their created date.

        ## Fields

          * `after` - Filter transactions created after this time.
          * `before` - Filter transactions created before this time.
        """

        defstruct [:after, :before]

        @type t :: %__MODULE__{
                after: DateTime.t() | nil,
                before: DateTime.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            after: Increase.Decode.datetime(raw["after"]),
            before: Increase.Decode.datetime(raw["before"])
          }
        end
      end

      defstruct [:account_id, :created_at]

      @type t :: %__MODULE__{
              account_id: String.t() | nil,
              created_at: CreatedAt.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_id: raw["account_id"],
          created_at: Increase.Decode.struct(raw["created_at"], &CreatedAt.decode/1)
        }
      end
    end

    defmodule VendorCsv do
      @moduledoc """
      Details of the vendor CSV export. This field will be present when the
      `category` is equal to `vendor_csv`.

      ## Fields

      """

      defstruct []

      @type t :: %__MODULE__{}

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{}
      end
    end

    defmodule VoidedCheck do
      @moduledoc """
      Details of the voided check export. This field will be present when the
      `category` is equal to `voided_check`.

      ## Fields

        * `account_number_id` - The Account Number for the voided check.
        * `payer` - The payer information printed on the check.
      """

      defmodule Payer do
        @moduledoc """
        The `ExportVoidedCheckPayer` object.

        ## Fields

          * `line` - The contents of the line.
        """

        defstruct [:line]

        @type t :: %__MODULE__{
                line: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            line: raw["line"]
          }
        end
      end

      defstruct [:account_number_id, :payer]

      @type t :: %__MODULE__{
              account_number_id: String.t(),
              payer: [Payer.t()]
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          account_number_id: raw["account_number_id"],
          payer: Increase.Decode.list(raw["payer"], &Payer.decode/1)
        }
      end
    end

    defstruct [
      :id,
      :account_statement_bai2,
      :account_statement_ofx,
      :account_verification_letter,
      :balance_csv,
      :bookkeeping_account_balance_csv,
      :category,
      :created_at,
      :daily_account_balance_csv,
      :dashboard_table_csv,
      :entity_csv,
      :fee_csv,
      :form_1099_int,
      :form_1099_misc,
      :funding_instructions,
      :idempotency_key,
      :result,
      :status,
      :transaction_csv,
      :type,
      :vendor_csv,
      :voided_check
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_statement_bai2: AccountStatementBai2.t() | nil,
            account_statement_ofx: AccountStatementOfx.t() | nil,
            account_verification_letter: AccountVerificationLetter.t() | nil,
            balance_csv: BalanceCsv.t() | nil,
            bookkeeping_account_balance_csv: BookkeepingAccountBalanceCsv.t() | nil,
            category: String.t(),
            created_at: DateTime.t(),
            daily_account_balance_csv: DailyAccountBalanceCsv.t() | nil,
            dashboard_table_csv: DashboardTableCsv.t() | nil,
            entity_csv: EntityCsv.t() | nil,
            fee_csv: FeeCsv.t() | nil,
            form_1099_int: Form1099Int.t() | nil,
            form_1099_misc: Form1099Misc.t() | nil,
            funding_instructions: FundingInstructions.t() | nil,
            idempotency_key: String.t() | nil,
            result: Result.t() | nil,
            status: String.t(),
            transaction_csv: TransactionCsv.t() | nil,
            type: String.t(),
            vendor_csv: VendorCsv.t() | nil,
            voided_check: VoidedCheck.t() | nil
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        account_statement_bai2:
          Increase.Decode.struct(raw["account_statement_bai2"], &AccountStatementBai2.decode/1),
        account_statement_ofx:
          Increase.Decode.struct(raw["account_statement_ofx"], &AccountStatementOfx.decode/1),
        account_verification_letter:
          Increase.Decode.struct(
            raw["account_verification_letter"],
            &AccountVerificationLetter.decode/1
          ),
        balance_csv: Increase.Decode.struct(raw["balance_csv"], &BalanceCsv.decode/1),
        bookkeeping_account_balance_csv:
          Increase.Decode.struct(
            raw["bookkeeping_account_balance_csv"],
            &BookkeepingAccountBalanceCsv.decode/1
          ),
        category: raw["category"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        daily_account_balance_csv:
          Increase.Decode.struct(
            raw["daily_account_balance_csv"],
            &DailyAccountBalanceCsv.decode/1
          ),
        dashboard_table_csv:
          Increase.Decode.struct(raw["dashboard_table_csv"], &DashboardTableCsv.decode/1),
        entity_csv: Increase.Decode.struct(raw["entity_csv"], &EntityCsv.decode/1),
        fee_csv: Increase.Decode.struct(raw["fee_csv"], &FeeCsv.decode/1),
        form_1099_int: Increase.Decode.struct(raw["form_1099_int"], &Form1099Int.decode/1),
        form_1099_misc: Increase.Decode.struct(raw["form_1099_misc"], &Form1099Misc.decode/1),
        funding_instructions:
          Increase.Decode.struct(raw["funding_instructions"], &FundingInstructions.decode/1),
        idempotency_key: raw["idempotency_key"],
        result: Increase.Decode.struct(raw["result"], &Result.decode/1),
        status: raw["status"],
        transaction_csv: Increase.Decode.struct(raw["transaction_csv"], &TransactionCsv.decode/1),
        type: raw["type"],
        vendor_csv: Increase.Decode.struct(raw["vendor_csv"], &VendorCsv.decode/1),
        voided_check: Increase.Decode.struct(raw["voided_check"], &VoidedCheck.decode/1)
      }
    end
  end

  @doc """
  Create an Export

  `POST /exports`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Export.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/exports"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Export.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an Export

  `GET /exports/{export_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Export.t()} | {:error, Increase.Error.t()}
  def retrieve(client, export_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/exports/#{export_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Export.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Exports

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  Export{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /exports`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/exports"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &Export.decode/1)}
      {:error, error} -> {:error, error}
    end
  end
end
