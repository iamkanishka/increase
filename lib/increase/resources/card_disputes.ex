defmodule Increase.CardDisputes do
  @moduledoc """
  If unauthorized activity occurs on a card, you can create a Card Dispute and
  we'll work with the card networks to return the funds if appropriate.

  See https://increase.com/documentation/api/card-disputes for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule CardDispute do
    @moduledoc """
    If unauthorized activity occurs on a card, you can create a Card Dispute and
    we'll work with the card networks to return the funds if appropriate.

    ## Fields

      * `id` - The Card Dispute identifier.
      * `amount` - The amount of the dispute.
      * `card_id` - The Card that the Card Dispute is associated with.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
        which the Card Dispute was created.
      * `disputed_transaction_id` - The identifier of the Transaction that was disputed.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `loss` - If the Card Dispute's status is `lost`, this will contain details of the lost
        dispute.
      * `network` - The network that the Card Dispute is associated with.
      * `rejection` - If the Card Dispute has been rejected, this will contain details of the
        rejection.
      * `status` - The status of the Card Dispute.
      * `type` - A constant representing the object's type. For this resource it will always be
        `card_dispute`.
      * `user_submission_required_by` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
        date and time at which the user submission is required
        by. Present only if status is `user_submission_required`
        and a user submission is required by a certain time.
        Otherwise, this will be `nil`.
      * `visa` - Card Dispute information for card payments processed over Visa's network. This
        field will be present in the JSON response if and only if `network` is equal to
        `visa`.
      * `win` - If the Card Dispute's status is `won`, this will contain details of the won
        dispute.
      * `withdrawal` - If the Card Dispute has been withdrawn, this will contain details of the
        withdrawal.
    """

    defmodule Loss do
      @moduledoc """
      If the Card Dispute's status is `lost`, this will contain details of the
      lost dispute.

      ## Fields

        * `lost_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the Card Dispute was lost.
        * `reason` - The reason the Card Dispute was lost.
      """

      defstruct [:lost_at, :reason]

      @type t :: %__MODULE__{
              lost_at: DateTime.t(),
              reason: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          lost_at: Increase.Decode.datetime(raw["lost_at"]),
          reason: raw["reason"]
        }
      end
    end

    defmodule Rejection do
      @moduledoc """
      If the Card Dispute has been rejected, this will contain details of the
      rejection.

      ## Fields

        * `explanation` - Why the Card Dispute was rejected.
        * `rejected_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
          at which the Card Dispute was rejected.
      """

      defstruct [:explanation, :rejected_at]

      @type t :: %__MODULE__{
              explanation: String.t(),
              rejected_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          explanation: raw["explanation"],
          rejected_at: Increase.Decode.datetime(raw["rejected_at"])
        }
      end
    end

    defmodule Visa do
      @moduledoc """
      Card Dispute information for card payments processed over Visa's network.
      This field will be present in the JSON response if and only if `network` is
      equal to `visa`.

      ## Fields

        * `network_events` - The network events for the Card Dispute.
          A map keyed by `"category"`. Exactly one of the
          following keys is present, matching that discriminator's value:

            * `"chargeback_accepted"`
            * `"chargeback_submitted"`
            * `"chargeback_timed_out"`
            * `"merchant_prearbitration_decline_submitted"`
            * `"merchant_prearbitration_received"`
            * `"merchant_prearbitration_timed_out"`
            * `"represented"`
            * `"representment_timed_out"`
            * `"user_prearbitration_accepted"`
            * `"user_prearbitration_declined"`
            * `"user_prearbitration_submitted"`
            * `"user_prearbitration_timed_out"`
            * `"user_withdrawal_submitted"`
        * `required_user_submission_category` - The category of the currently required user
          submission if the user wishes to proceed with
          the dispute. Present if and only if status is
          `user_submission_required`. Otherwise, this will
          be `nil`.
        * `user_submissions` - The user submissions for the Card Dispute.
      """

      defmodule UserSubmission do
        @moduledoc """
        The `CardDisputeVisaUserSubmission` object.

        ## Fields

          * `accepted_at` - The date and time at which the Visa Card Dispute User Submission was
            reviewed and accepted.
          * `amount` - The amount of the dispute if it is different from the amount of a prior
            user submission or the disputed transaction.
          * `attachment_files` - The files attached to the Visa Card Dispute User Submission.
          * `category` - The category of the user submission. We may add additional possible
            values for this enum over time; your application should be able to
            handle such additions gracefully.
          * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
            at which the Visa Card Dispute User Submission was created.
          * `explanation` - The free-form explanation provided to Increase to provide more
            context for the user submission. This field is not sent directly to
            the card networks.
          * `further_information_requested_at` - The date and time at which Increase requested
            further information from the user for the Visa
            Card Dispute.
          * `further_information_requested_reason` - The reason for Increase requesting further
            information from the user for the Visa Card
            Dispute.
          * `status` - The status of the Visa Card Dispute User Submission.
          * `updated_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time
            at which the Visa Card Dispute User Submission was updated.
          * `chargeback` - A Visa Card Dispute Chargeback User Submission Chargeback Details
            object. This field will be present in the JSON response if and only
            if `category` is equal to `chargeback`. Contains the details specific
            to a Visa chargeback User Submission for a Card Dispute.
            A map keyed by `"category"`. Exactly one of the
            following keys is present, matching that discriminator's value:

              * `"authorization"`
              * `"consumer_canceled_merchandise"`
              * `"consumer_canceled_recurring_transaction"`
              * `"consumer_canceled_services"`
              * `"consumer_counterfeit_merchandise"`
              * `"consumer_credit_not_processed"`
              * `"consumer_damaged_or_defective_merchandise"`
              * `"consumer_merchandise_misrepresentation"`
              * `"consumer_merchandise_not_as_described"`
              * `"consumer_merchandise_not_received"`
              * `"consumer_non_receipt_of_cash"`
              * `"consumer_original_credit_transaction_not_accepted"`
              * `"consumer_quality_merchandise"`
              * `"consumer_quality_services"`
              * `"consumer_services_misrepresentation"`
              * `"consumer_services_not_as_described"`
              * `"consumer_services_not_received"`
              * `"fraud"`
              * `"processing_error"`
          * `merchant_prearbitration_decline` - A Visa Card Dispute Merchant Pre-Arbitration
            Decline User Submission object. This field will
            be present in the JSON response if and only if
            `category` is equal to
            `merchant_prearbitration_decline`. Contains the
            details specific to a merchant prearbitration
            decline Visa Card Dispute User Submission.
          * `user_prearbitration` - A Visa Card Dispute User-Initiated Pre-Arbitration User
            Submission object. This field will be present in the JSON
            response if and only if `category` is equal to
            `user_prearbitration`. Contains the details specific to a
            user-initiated pre-arbitration Visa Card Dispute User
            Submission.
        """

        defmodule CardDisputeVisaUserSubmissionsAttachmentFile do
          @moduledoc """
          The `CardDisputeVisaUserSubmissionsAttachmentFile` object.

          ## Fields

            * `file_id` - The ID of the file attached to the Card Dispute.
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

        defmodule CardDisputeVisaUserSubmissionsMerchantPrearbitrationDecline do
          @moduledoc """
          A Visa Card Dispute Merchant Pre-Arbitration Decline User Submission object.
          This field will be present in the JSON response if and only if `category` is
          equal to `merchant_prearbitration_decline`. Contains the details specific to
          a merchant prearbitration decline Visa Card Dispute User Submission.

          ## Fields

            * `reason` - The reason the user declined the merchant's request for pre-arbitration
              in their favor.
          """

          defstruct [:reason]

          @type t :: %__MODULE__{
                  reason: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              reason: raw["reason"]
            }
          end
        end

        defmodule CardDisputeVisaUserSubmissionsUserPrearbitration do
          @moduledoc """
          A Visa Card Dispute User-Initiated Pre-Arbitration User Submission object.
          This field will be present in the JSON response if and only if `category` is
          equal to `user_prearbitration`. Contains the details specific to a
          user-initiated pre-arbitration Visa Card Dispute User Submission.

          ## Fields

            * `category_change` - Category change details for the pre-arbitration request, if
              requested.
            * `reason` - The reason for the pre-arbitration request.
          """

          defmodule CategoryChange do
            @moduledoc """
            Category change details for the pre-arbitration request, if requested.

            ## Fields

              * `category` - The category the dispute is being changed to.
              * `reason` - The reason for the pre-arbitration request.
            """

            defstruct [:category, :reason]

            @type t :: %__MODULE__{
                    category: String.t(),
                    reason: String.t()
                  }

            @doc false
            @spec decode(map()) :: t()
            def decode(raw) when is_map(raw) do
              %__MODULE__{
                category: raw["category"],
                reason: raw["reason"]
              }
            end
          end

          defstruct [:category_change, :reason]

          @type t :: %__MODULE__{
                  category_change: CategoryChange.t() | nil,
                  reason: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              category_change:
                Increase.Decode.struct(raw["category_change"], &CategoryChange.decode/1),
              reason: raw["reason"]
            }
          end
        end

        defstruct [
          :accepted_at,
          :amount,
          :attachment_files,
          :category,
          :created_at,
          :explanation,
          :further_information_requested_at,
          :further_information_requested_reason,
          :status,
          :updated_at,
          :chargeback,
          :merchant_prearbitration_decline,
          :user_prearbitration
        ]

        @type t :: %__MODULE__{
                accepted_at: DateTime.t() | nil,
                amount: integer() | nil,
                attachment_files: [CardDisputeVisaUserSubmissionsAttachmentFile.t()],
                category: String.t(),
                created_at: DateTime.t(),
                explanation: String.t() | nil,
                further_information_requested_at: DateTime.t() | nil,
                further_information_requested_reason: String.t() | nil,
                status: String.t(),
                updated_at: DateTime.t(),
                chargeback: map() | nil,
                merchant_prearbitration_decline:
                  CardDisputeVisaUserSubmissionsMerchantPrearbitrationDecline.t() | nil,
                user_prearbitration: CardDisputeVisaUserSubmissionsUserPrearbitration.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            accepted_at: Increase.Decode.datetime(raw["accepted_at"]),
            amount: raw["amount"],
            attachment_files:
              Increase.Decode.list(
                raw["attachment_files"],
                &CardDisputeVisaUserSubmissionsAttachmentFile.decode/1
              ),
            category: raw["category"],
            created_at: Increase.Decode.datetime(raw["created_at"]),
            explanation: raw["explanation"],
            further_information_requested_at:
              Increase.Decode.datetime(raw["further_information_requested_at"]),
            further_information_requested_reason: raw["further_information_requested_reason"],
            status: raw["status"],
            updated_at: Increase.Decode.datetime(raw["updated_at"]),
            chargeback: raw["chargeback"],
            merchant_prearbitration_decline:
              Increase.Decode.struct(
                raw["merchant_prearbitration_decline"],
                &CardDisputeVisaUserSubmissionsMerchantPrearbitrationDecline.decode/1
              ),
            user_prearbitration:
              Increase.Decode.struct(
                raw["user_prearbitration"],
                &CardDisputeVisaUserSubmissionsUserPrearbitration.decode/1
              )
          }
        end
      end

      defstruct [:network_events, :required_user_submission_category, :user_submissions]

      @type t :: %__MODULE__{
              network_events: [map()],
              required_user_submission_category: String.t() | nil,
              user_submissions: [UserSubmission.t()]
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          network_events: raw["network_events"],
          required_user_submission_category: raw["required_user_submission_category"],
          user_submissions:
            Increase.Decode.list(raw["user_submissions"], &UserSubmission.decode/1)
        }
      end
    end

    defmodule Win do
      @moduledoc """
      If the Card Dispute's status is `won`, this will contain details of the won
      dispute.

      ## Fields

        * `won_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date and time at
          which the Card Dispute was won.
      """

      defstruct [:won_at]

      @type t :: %__MODULE__{
              won_at: DateTime.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          won_at: Increase.Decode.datetime(raw["won_at"])
        }
      end
    end

    defmodule Withdrawal do
      @moduledoc """
      If the Card Dispute has been withdrawn, this will contain details of the
      withdrawal.

      ## Fields

        * `explanation` - The explanation for the withdrawal of the Card Dispute.
      """

      defstruct [:explanation]

      @type t :: %__MODULE__{
              explanation: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          explanation: raw["explanation"]
        }
      end
    end

    defstruct [
      :id,
      :amount,
      :card_id,
      :created_at,
      :disputed_transaction_id,
      :idempotency_key,
      :loss,
      :network,
      :rejection,
      :status,
      :type,
      :user_submission_required_by,
      :visa,
      :win,
      :withdrawal
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            amount: integer(),
            card_id: String.t(),
            created_at: DateTime.t(),
            disputed_transaction_id: String.t(),
            idempotency_key: String.t() | nil,
            loss: Loss.t() | nil,
            network: String.t(),
            rejection: Rejection.t() | nil,
            status: String.t(),
            type: String.t(),
            user_submission_required_by: DateTime.t() | nil,
            visa: Visa.t() | nil,
            win: Win.t() | nil,
            withdrawal: Withdrawal.t() | nil
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        amount: raw["amount"],
        card_id: raw["card_id"],
        created_at: Increase.Decode.datetime(raw["created_at"]),
        disputed_transaction_id: raw["disputed_transaction_id"],
        idempotency_key: raw["idempotency_key"],
        loss: Increase.Decode.struct(raw["loss"], &Loss.decode/1),
        network: raw["network"],
        rejection: Increase.Decode.struct(raw["rejection"], &Rejection.decode/1),
        status: raw["status"],
        type: raw["type"],
        user_submission_required_by: Increase.Decode.datetime(raw["user_submission_required_by"]),
        visa: Increase.Decode.struct(raw["visa"], &Visa.decode/1),
        win: Increase.Decode.struct(raw["win"], &Win.decode/1),
        withdrawal: Increase.Decode.struct(raw["withdrawal"], &Withdrawal.decode/1)
      }
    end
  end

  @doc """
  Create a Card Dispute

  `POST /card_disputes`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, CardDispute.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_disputes"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CardDispute.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve a Card Dispute

  `GET /card_disputes/{card_dispute_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, CardDispute.t()} | {:error, Increase.Error.t()}
  def retrieve(client, card_dispute_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_disputes/#{card_dispute_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, CardDispute.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Card Disputes

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  CardDispute{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /card_disputes`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_disputes"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &CardDispute.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Submit a User Submission for a Card Dispute

  `POST /card_disputes/{card_dispute_id}/submit_user_submission`
  """
  @spec submit_user_submission(
          Increase.Client.t() | keyword() | nil,
          String.t(),
          map() | keyword(),
          keyword()
        ) ::
          {:ok, CardDispute.t()} | {:error, Increase.Error.t()}
  def submit_user_submission(client, card_dispute_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_disputes/#{card_dispute_id}/submit_user_submission"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CardDispute.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Withdraw a Card Dispute

  `POST /card_disputes/{card_dispute_id}/withdraw`
  """
  @spec withdraw(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, CardDispute.t()} | {:error, Increase.Error.t()}
  def withdraw(client, card_dispute_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/card_disputes/#{card_dispute_id}/withdraw"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, CardDispute.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
