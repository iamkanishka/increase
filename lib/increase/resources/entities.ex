defmodule Increase.Entities do
  @moduledoc """
  Entities are the legal entities that own accounts. They can be people,
  corporations, partnerships, government authorities, or trusts. To learn more,
  see [Entities].

  See https://increase.com/documentation/api/entities for the full API
  reference for this resource.
  """

  alias Increase.Client
  alias Increase.Page

  defmodule Entity do
    @moduledoc """
    Entities are the legal entities that own accounts. They can be people,
    corporations, partnerships, government authorities, or trusts. To learn
    more, see [Entities].

    ## Fields

      * `id` - The entity's identifier.
      * `corporation` - Details of the corporation entity. Will be present if `structure` is
        equal to `corporation`.
      * `created_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
        Entity was created.
      * `creating_entity_onboarding_session_id` - The identifier of the Entity Onboarding
        Session that was used to create this Entity,
        if any.
      * `description` - The entity's description for display purposes.
      * `details_confirmed_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at
        which the Entity's details were most recently confirmed.
      * `government_authority` - Details of the government authority entity. Will be present if
        `structure` is equal to `government_authority`.
      * `idempotency_key` - The idempotency key you chose for this object. This value is unique
        across Increase and is used to ensure that a request is only
        processed once. Learn more about
        [idempotency](https://increase.com/documentation/idempotency-keys).
      * `joint` - Details of the joint entity. Will be present if `structure` is equal to
        `joint`.
      * `natural_person` - Details of the natural person entity. Will be present if `structure`
        is equal to `natural_person`.
      * `risk_rating` - An assessment of the entity’s potential risk of involvement in financial
        crimes, such as money laundering.
      * `status` - The status of the entity.
      * `structure` - The entity's legal structure.
      * `supplemental_documents` - Additional documentation associated with the entity. This is
        limited to the first 10 documents for an entity. If an entity
        has more than 10 documents, use the GET
        /entity_supplemental_documents list endpoint to retrieve
        them.
      * `terms_agreements` - The terms that the Entity agreed to. Not all programs are required
        to submit this data.
      * `third_party_verification` - If you are using a third-party service for identity
        verification, you can use this field to associate this
        Entity with the identifier that represents them in that
        service.
      * `trust` - Details of the trust entity. Will be present if `structure` is equal to
        `trust`.
      * `type` - A constant representing the object's type. For this resource it will always be
        `entity`.
      * `validation` - The validation results for the entity. Learn more about
        [validations].
    """

    defmodule Corporation do
      @moduledoc """
      Details of the corporation entity. Will be present if `structure` is equal
      to `corporation`.

      ## Fields

        * `address` - The corporation's address.
        * `beneficial_owners` - The identifying details of anyone controlling or owning 25% or
          more of the corporation.
        * `beneficial_ownership_exemption_reason` - If the entity is exempt from the requirement
          to submit beneficial owners, the
          justification for the exemption.
        * `email` - An email address for the business.
        * `incorporation_state` - The two-letter United States Postal Service (USPS)
          abbreviation for the corporation's state of incorporation.
        * `industry_code` - The numeric North American Industry Classification System (NAICS)
          code submitted for the corporation.
        * `legal_identifier` - The legal identifier of the corporation.
        * `name` - The legal name of the corporation.
        * `website` - The website of the corporation.
      """

      defmodule Address do
        @moduledoc """
        The corporation's address.

        ## Fields

          * `city` - The city, district, town, or village of the address.
          * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the address.
          * `line1` - The first line of the address.
          * `line2` - The second line of the address.
          * `state` - The two-letter United States Postal Service (USPS) abbreviation for the US
            state, province, or region of the address.
          * `zip` - The ZIP or postal code of the address.
        """

        defstruct [:city, :country, :line1, :line2, :state, :zip]

        @type t :: %__MODULE__{
                city: String.t() | nil,
                country: String.t(),
                line1: String.t(),
                line2: String.t() | nil,
                state: String.t() | nil,
                zip: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            country: raw["country"],
            line1: raw["line1"],
            line2: raw["line2"],
            state: raw["state"],
            zip: raw["zip"]
          }
        end
      end

      defmodule BeneficialOwner do
        @moduledoc """
        The `EntityCorporationBeneficialOwner` object.

        ## Fields

          * `id` - The identifier of this beneficial owner.
          * `company_title` - This person's role or title within the entity.
          * `individual` - Personal details for the beneficial owner.
          * `prongs` - Why this person is considered a beneficial owner of the entity.
        """

        defmodule EntityCorporationBeneficialOwnersIndividual do
          @moduledoc """
          Personal details for the beneficial owner.

          ## Fields

            * `address` - The person's address.
            * `date_of_birth` - The person's date of birth in YYYY-MM-DD format.
            * `identification` - A means of verifying the person's identity.
            * `name` - The person's legal name.
          """

          defmodule Address do
            @moduledoc """
            The person's address.

            ## Fields

              * `city` - The city, district, town, or village of the address.
              * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the
                address.
              * `line1` - The first line of the address.
              * `line2` - The second line of the address.
              * `state` - The two-letter United States Postal Service (USPS) abbreviation for
                the US state, province, or region of the address.
              * `zip` - The ZIP or postal code of the address.
            """

            defstruct [:city, :country, :line1, :line2, :state, :zip]

            @type t :: %__MODULE__{
                    city: String.t() | nil,
                    country: String.t(),
                    line1: String.t(),
                    line2: String.t() | nil,
                    state: String.t() | nil,
                    zip: String.t() | nil
                  }

            @doc false
            @spec decode(map()) :: t()
            def decode(raw) when is_map(raw) do
              %__MODULE__{
                city: raw["city"],
                country: raw["country"],
                line1: raw["line1"],
                line2: raw["line2"],
                state: raw["state"],
                zip: raw["zip"]
              }
            end
          end

          defmodule Identification do
            @moduledoc """
            A means of verifying the person's identity.

            ## Fields

              * `method` - A method that can be used to verify the individual's identity.
              * `number_last4` - The last 4 digits of the identification number that can be used
                to verify the individual's identity.
            """

            defstruct [:method, :number_last4]

            @type t :: %__MODULE__{
                    method: String.t(),
                    number_last4: String.t()
                  }

            @doc false
            @spec decode(map()) :: t()
            def decode(raw) when is_map(raw) do
              %__MODULE__{
                method: raw["method"],
                number_last4: raw["number_last4"]
              }
            end
          end

          defstruct [:address, :date_of_birth, :identification, :name]

          @type t :: %__MODULE__{
                  address: Address.t(),
                  date_of_birth: Date.t(),
                  identification: Identification.t() | nil,
                  name: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              address: Increase.Decode.struct(raw["address"], &Address.decode/1),
              date_of_birth: Increase.Decode.date(raw["date_of_birth"]),
              identification:
                Increase.Decode.struct(raw["identification"], &Identification.decode/1),
              name: raw["name"]
            }
          end
        end

        defstruct [:id, :company_title, :individual, :prongs]

        @type t :: %__MODULE__{
                id: String.t(),
                company_title: String.t() | nil,
                individual: EntityCorporationBeneficialOwnersIndividual.t(),
                prongs: [String.t()]
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            id: raw["id"],
            company_title: raw["company_title"],
            individual:
              Increase.Decode.struct(
                raw["individual"],
                &EntityCorporationBeneficialOwnersIndividual.decode/1
              ),
            prongs: raw["prongs"]
          }
        end
      end

      defmodule LegalIdentifier do
        @moduledoc """
        The legal identifier of the corporation.

        ## Fields

          * `category` - The category of the legal identifier.
          * `value` - The identifier of the legal identifier.
        """

        defstruct [:category, :value]

        @type t :: %__MODULE__{
                category: String.t(),
                value: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            category: raw["category"],
            value: raw["value"]
          }
        end
      end

      defstruct [
        :address,
        :beneficial_owners,
        :beneficial_ownership_exemption_reason,
        :email,
        :incorporation_state,
        :industry_code,
        :legal_identifier,
        :name,
        :website
      ]

      @type t :: %__MODULE__{
              address: Address.t(),
              beneficial_owners: [BeneficialOwner.t()],
              beneficial_ownership_exemption_reason: String.t() | nil,
              email: String.t() | nil,
              incorporation_state: String.t() | nil,
              industry_code: String.t() | nil,
              legal_identifier: LegalIdentifier.t() | nil,
              name: String.t(),
              website: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          beneficial_owners:
            Increase.Decode.list(raw["beneficial_owners"], &BeneficialOwner.decode/1),
          beneficial_ownership_exemption_reason: raw["beneficial_ownership_exemption_reason"],
          email: raw["email"],
          incorporation_state: raw["incorporation_state"],
          industry_code: raw["industry_code"],
          legal_identifier:
            Increase.Decode.struct(raw["legal_identifier"], &LegalIdentifier.decode/1),
          name: raw["name"],
          website: raw["website"]
        }
      end
    end

    defmodule GovernmentAuthority do
      @moduledoc """
      Details of the government authority entity. Will be present if `structure`
      is equal to `government_authority`.

      ## Fields

        * `address` - The government authority's address.
        * `authorized_persons` - The identifying details of authorized persons of the government
          authority.
        * `category` - The category of the government authority.
        * `name` - The government authority's name.
        * `tax_identifier` - The Employer Identification Number (EIN) of the government
          authority.
        * `website` - The government authority's website.
      """

      defmodule Address do
        @moduledoc """
        The government authority's address.

        ## Fields

          * `city` - The city, district, town, or village of the address.
          * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the address.
          * `line1` - The first line of the address.
          * `line2` - The second line of the address.
          * `state` - The two-letter United States Postal Service (USPS) abbreviation for the US
            state, province, or region of the address.
          * `zip` - The ZIP or postal code of the address.
        """

        defstruct [:city, :country, :line1, :line2, :state, :zip]

        @type t :: %__MODULE__{
                city: String.t() | nil,
                country: String.t(),
                line1: String.t(),
                line2: String.t() | nil,
                state: String.t() | nil,
                zip: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            country: raw["country"],
            line1: raw["line1"],
            line2: raw["line2"],
            state: raw["state"],
            zip: raw["zip"]
          }
        end
      end

      defmodule AuthorizedPerson do
        @moduledoc """
        The `EntityGovernmentAuthorityAuthorizedPerson` object.

        ## Fields

          * `authorized_person_id` - The identifier of this authorized person.
          * `name` - The person's legal name.
        """

        defstruct [:authorized_person_id, :name]

        @type t :: %__MODULE__{
                authorized_person_id: String.t(),
                name: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            authorized_person_id: raw["authorized_person_id"],
            name: raw["name"]
          }
        end
      end

      defstruct [:address, :authorized_persons, :category, :name, :tax_identifier, :website]

      @type t :: %__MODULE__{
              address: Address.t(),
              authorized_persons: [AuthorizedPerson.t()],
              category: String.t(),
              name: String.t(),
              tax_identifier: String.t() | nil,
              website: String.t() | nil
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          authorized_persons:
            Increase.Decode.list(raw["authorized_persons"], &AuthorizedPerson.decode/1),
          category: raw["category"],
          name: raw["name"],
          tax_identifier: raw["tax_identifier"],
          website: raw["website"]
        }
      end
    end

    defmodule Joint do
      @moduledoc """
      Details of the joint entity. Will be present if `structure` is equal to
      `joint`.

      ## Fields

        * `individuals` - The two individuals that share control of the entity.
        * `name` - The entity's name.
      """

      defmodule Individual do
        @moduledoc """
        The `EntityJointIndividual` object.

        ## Fields

          * `address` - The person's address.
          * `date_of_birth` - The person's date of birth in YYYY-MM-DD format.
          * `identification` - A means of verifying the person's identity.
          * `name` - The person's legal name.
        """

        defmodule EntityJointIndividualsAddress do
          @moduledoc """
          The person's address.

          ## Fields

            * `city` - The city, district, town, or village of the address.
            * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the address.
            * `line1` - The first line of the address.
            * `line2` - The second line of the address.
            * `state` - The two-letter United States Postal Service (USPS) abbreviation for the
              US state, province, or region of the address.
            * `zip` - The ZIP or postal code of the address.
          """

          defstruct [:city, :country, :line1, :line2, :state, :zip]

          @type t :: %__MODULE__{
                  city: String.t() | nil,
                  country: String.t(),
                  line1: String.t(),
                  line2: String.t() | nil,
                  state: String.t() | nil,
                  zip: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              city: raw["city"],
              country: raw["country"],
              line1: raw["line1"],
              line2: raw["line2"],
              state: raw["state"],
              zip: raw["zip"]
            }
          end
        end

        defmodule EntityJointIndividualsIdentification do
          @moduledoc """
          A means of verifying the person's identity.

          ## Fields

            * `method` - A method that can be used to verify the individual's identity.
            * `number_last4` - The last 4 digits of the identification number that can be used
              to verify the individual's identity.
          """

          defstruct [:method, :number_last4]

          @type t :: %__MODULE__{
                  method: String.t(),
                  number_last4: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              method: raw["method"],
              number_last4: raw["number_last4"]
            }
          end
        end

        defstruct [:address, :date_of_birth, :identification, :name]

        @type t :: %__MODULE__{
                address: EntityJointIndividualsAddress.t(),
                date_of_birth: Date.t(),
                identification: EntityJointIndividualsIdentification.t() | nil,
                name: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            address:
              Increase.Decode.struct(raw["address"], &EntityJointIndividualsAddress.decode/1),
            date_of_birth: Increase.Decode.date(raw["date_of_birth"]),
            identification:
              Increase.Decode.struct(
                raw["identification"],
                &EntityJointIndividualsIdentification.decode/1
              ),
            name: raw["name"]
          }
        end
      end

      defstruct [:individuals, :name]

      @type t :: %__MODULE__{
              individuals: [Individual.t()],
              name: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          individuals: Increase.Decode.list(raw["individuals"], &Individual.decode/1),
          name: raw["name"]
        }
      end
    end

    defmodule NaturalPerson do
      @moduledoc """
      Details of the natural person entity. Will be present if `structure` is
      equal to `natural_person`.

      ## Fields

        * `address` - The person's address.
        * `date_of_birth` - The person's date of birth in YYYY-MM-DD format.
        * `identification` - A means of verifying the person's identity.
        * `name` - The person's legal name.
      """

      defmodule Address do
        @moduledoc """
        The person's address.

        ## Fields

          * `city` - The city, district, town, or village of the address.
          * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the address.
          * `line1` - The first line of the address.
          * `line2` - The second line of the address.
          * `state` - The two-letter United States Postal Service (USPS) abbreviation for the US
            state, province, or region of the address.
          * `zip` - The ZIP or postal code of the address.
        """

        defstruct [:city, :country, :line1, :line2, :state, :zip]

        @type t :: %__MODULE__{
                city: String.t() | nil,
                country: String.t(),
                line1: String.t(),
                line2: String.t() | nil,
                state: String.t() | nil,
                zip: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            country: raw["country"],
            line1: raw["line1"],
            line2: raw["line2"],
            state: raw["state"],
            zip: raw["zip"]
          }
        end
      end

      defmodule Identification do
        @moduledoc """
        A means of verifying the person's identity.

        ## Fields

          * `method` - A method that can be used to verify the individual's identity.
          * `number_last4` - The last 4 digits of the identification number that can be used to
            verify the individual's identity.
        """

        defstruct [:method, :number_last4]

        @type t :: %__MODULE__{
                method: String.t(),
                number_last4: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            method: raw["method"],
            number_last4: raw["number_last4"]
          }
        end
      end

      defstruct [:address, :date_of_birth, :identification, :name]

      @type t :: %__MODULE__{
              address: Address.t(),
              date_of_birth: Date.t(),
              identification: Identification.t() | nil,
              name: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          date_of_birth: Increase.Decode.date(raw["date_of_birth"]),
          identification: Increase.Decode.struct(raw["identification"], &Identification.decode/1),
          name: raw["name"]
        }
      end
    end

    defmodule RiskRating do
      @moduledoc """
      An assessment of the entity’s potential risk of involvement in financial
      crimes, such as money laundering.

      ## Fields

        * `rated_at` - The [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) time at which the
          risk rating was performed.
        * `rating` - The rating given to this entity.
      """

      defstruct [:rated_at, :rating]

      @type t :: %__MODULE__{
              rated_at: DateTime.t(),
              rating: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          rated_at: Increase.Decode.datetime(raw["rated_at"]),
          rating: raw["rating"]
        }
      end
    end

    defmodule TermsAgreement do
      @moduledoc """
      The `EntityTermsAgreement` object.

      ## Fields

        * `agreed_at` - The timestamp of when the Entity agreed to the terms.
        * `ip_address` - The IP address the Entity accessed reviewed the terms from.
        * `terms_url` - The URL of the terms agreement. This link will be provided by your bank
          partner.
      """

      defstruct [:agreed_at, :ip_address, :terms_url]

      @type t :: %__MODULE__{
              agreed_at: DateTime.t(),
              ip_address: String.t(),
              terms_url: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          agreed_at: Increase.Decode.datetime(raw["agreed_at"]),
          ip_address: raw["ip_address"],
          terms_url: raw["terms_url"]
        }
      end
    end

    defmodule ThirdPartyVerification do
      @moduledoc """
      If you are using a third-party service for identity verification, you can
      use this field to associate this Entity with the identifier that represents
      them in that service.

      ## Fields

        * `reference` - The reference identifier for the third party verification.
        * `vendor` - The vendor that was used to perform the verification.
      """

      defstruct [:reference, :vendor]

      @type t :: %__MODULE__{
              reference: String.t(),
              vendor: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          reference: raw["reference"],
          vendor: raw["vendor"]
        }
      end
    end

    defmodule Trust do
      @moduledoc """
      Details of the trust entity. Will be present if `structure` is equal to
      `trust`.

      ## Fields

        * `address` - The trust's address.
        * `category` - Whether the trust is `revocable` or `irrevocable`.
        * `formation_document_file_id` - The ID for the File containing the formation document
          of the trust.
        * `formation_state` - The two-letter United States Postal Service (USPS) abbreviation
          for the state in which the trust was formed.
        * `grantor` - The grantor of the trust. Will be present if the `category` is
          `revocable`.
        * `name` - The trust's name.
        * `tax_identifier` - The Employer Identification Number (EIN) of the trust itself.
        * `trustees` - The trustees of the trust.
      """

      defmodule Address do
        @moduledoc """
        The trust's address.

        ## Fields

          * `city` - The city, district, town, or village of the address.
          * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the address.
          * `line1` - The first line of the address.
          * `line2` - The second line of the address.
          * `state` - The two-letter United States Postal Service (USPS) abbreviation for the US
            state, province, or region of the address.
          * `zip` - The ZIP or postal code of the address.
        """

        defstruct [:city, :country, :line1, :line2, :state, :zip]

        @type t :: %__MODULE__{
                city: String.t() | nil,
                country: String.t(),
                line1: String.t(),
                line2: String.t() | nil,
                state: String.t() | nil,
                zip: String.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            city: raw["city"],
            country: raw["country"],
            line1: raw["line1"],
            line2: raw["line2"],
            state: raw["state"],
            zip: raw["zip"]
          }
        end
      end

      defmodule Grantor do
        @moduledoc """
        The grantor of the trust. Will be present if the `category` is `revocable`.

        ## Fields

          * `address` - The person's address.
          * `date_of_birth` - The person's date of birth in YYYY-MM-DD format.
          * `identification` - A means of verifying the person's identity.
          * `name` - The person's legal name.
        """

        defmodule Address do
          @moduledoc """
          The person's address.

          ## Fields

            * `city` - The city, district, town, or village of the address.
            * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the address.
            * `line1` - The first line of the address.
            * `line2` - The second line of the address.
            * `state` - The two-letter United States Postal Service (USPS) abbreviation for the
              US state, province, or region of the address.
            * `zip` - The ZIP or postal code of the address.
          """

          defstruct [:city, :country, :line1, :line2, :state, :zip]

          @type t :: %__MODULE__{
                  city: String.t() | nil,
                  country: String.t(),
                  line1: String.t(),
                  line2: String.t() | nil,
                  state: String.t() | nil,
                  zip: String.t() | nil
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              city: raw["city"],
              country: raw["country"],
              line1: raw["line1"],
              line2: raw["line2"],
              state: raw["state"],
              zip: raw["zip"]
            }
          end
        end

        defmodule Identification do
          @moduledoc """
          A means of verifying the person's identity.

          ## Fields

            * `method` - A method that can be used to verify the individual's identity.
            * `number_last4` - The last 4 digits of the identification number that can be used
              to verify the individual's identity.
          """

          defstruct [:method, :number_last4]

          @type t :: %__MODULE__{
                  method: String.t(),
                  number_last4: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              method: raw["method"],
              number_last4: raw["number_last4"]
            }
          end
        end

        defstruct [:address, :date_of_birth, :identification, :name]

        @type t :: %__MODULE__{
                address: Address.t(),
                date_of_birth: Date.t(),
                identification: Identification.t() | nil,
                name: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            address: Increase.Decode.struct(raw["address"], &Address.decode/1),
            date_of_birth: Increase.Decode.date(raw["date_of_birth"]),
            identification:
              Increase.Decode.struct(raw["identification"], &Identification.decode/1),
            name: raw["name"]
          }
        end
      end

      defmodule Trustee do
        @moduledoc """
        The `EntityTrustTrustee` object.

        ## Fields

          * `individual` - The individual trustee of the trust. Will be present if the trustee's
            `structure` is equal to `individual`.
          * `structure` - The structure of the trustee. Will always be equal to `individual`.
        """

        defmodule EntityTrustTrusteesIndividual do
          @moduledoc """
          The individual trustee of the trust. Will be present if the trustee's
          `structure` is equal to `individual`.

          ## Fields

            * `address` - The person's address.
            * `date_of_birth` - The person's date of birth in YYYY-MM-DD format.
            * `identification` - A means of verifying the person's identity.
            * `name` - The person's legal name.
          """

          defmodule Address do
            @moduledoc """
            The person's address.

            ## Fields

              * `city` - The city, district, town, or village of the address.
              * `country` - The two-letter ISO 3166-1 alpha-2 code for the country of the
                address.
              * `line1` - The first line of the address.
              * `line2` - The second line of the address.
              * `state` - The two-letter United States Postal Service (USPS) abbreviation for
                the US state, province, or region of the address.
              * `zip` - The ZIP or postal code of the address.
            """

            defstruct [:city, :country, :line1, :line2, :state, :zip]

            @type t :: %__MODULE__{
                    city: String.t() | nil,
                    country: String.t(),
                    line1: String.t(),
                    line2: String.t() | nil,
                    state: String.t() | nil,
                    zip: String.t() | nil
                  }

            @doc false
            @spec decode(map()) :: t()
            def decode(raw) when is_map(raw) do
              %__MODULE__{
                city: raw["city"],
                country: raw["country"],
                line1: raw["line1"],
                line2: raw["line2"],
                state: raw["state"],
                zip: raw["zip"]
              }
            end
          end

          defmodule Identification do
            @moduledoc """
            A means of verifying the person's identity.

            ## Fields

              * `method` - A method that can be used to verify the individual's identity.
              * `number_last4` - The last 4 digits of the identification number that can be used
                to verify the individual's identity.
            """

            defstruct [:method, :number_last4]

            @type t :: %__MODULE__{
                    method: String.t(),
                    number_last4: String.t()
                  }

            @doc false
            @spec decode(map()) :: t()
            def decode(raw) when is_map(raw) do
              %__MODULE__{
                method: raw["method"],
                number_last4: raw["number_last4"]
              }
            end
          end

          defstruct [:address, :date_of_birth, :identification, :name]

          @type t :: %__MODULE__{
                  address: Address.t(),
                  date_of_birth: Date.t(),
                  identification: Identification.t() | nil,
                  name: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              address: Increase.Decode.struct(raw["address"], &Address.decode/1),
              date_of_birth: Increase.Decode.date(raw["date_of_birth"]),
              identification:
                Increase.Decode.struct(raw["identification"], &Identification.decode/1),
              name: raw["name"]
            }
          end
        end

        defstruct [:individual, :structure]

        @type t :: %__MODULE__{
                individual: EntityTrustTrusteesIndividual.t() | nil,
                structure: String.t()
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            individual:
              Increase.Decode.struct(raw["individual"], &EntityTrustTrusteesIndividual.decode/1),
            structure: raw["structure"]
          }
        end
      end

      defstruct [
        :address,
        :category,
        :formation_document_file_id,
        :formation_state,
        :grantor,
        :name,
        :tax_identifier,
        :trustees
      ]

      @type t :: %__MODULE__{
              address: Address.t(),
              category: String.t(),
              formation_document_file_id: String.t() | nil,
              formation_state: String.t() | nil,
              grantor: Grantor.t() | nil,
              name: String.t(),
              tax_identifier: String.t() | nil,
              trustees: [Trustee.t()]
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          address: Increase.Decode.struct(raw["address"], &Address.decode/1),
          category: raw["category"],
          formation_document_file_id: raw["formation_document_file_id"],
          formation_state: raw["formation_state"],
          grantor: Increase.Decode.struct(raw["grantor"], &Grantor.decode/1),
          name: raw["name"],
          tax_identifier: raw["tax_identifier"],
          trustees: Increase.Decode.list(raw["trustees"], &Trustee.decode/1)
        }
      end
    end

    defmodule Validation do
      @moduledoc """
      The validation results for the entity. Learn more about
      [validations]

      ## Fields

        * `issues` - The list of issues that need to be addressed.
        * `status` - The validation status for the entity. If the status is `invalid`, the
          `issues` array will be populated.
      """

      defmodule Issue do
        @moduledoc """
        The `EntityValidationIssue` object.

        ## Fields

          * `beneficial_owner_address` - Details when the issue is with a beneficial owner's
            address.
          * `beneficial_owner_identity` - Details when the issue is with a beneficial owner's
            identity verification.
          * `category` - The type of issue. We may add additional possible values for this enum
            over time; your application should be able to handle such additions
            gracefully.
          * `entity_address` - Details when the issue is with the entity's address.
          * `entity_tax_identifier` - Details when the issue is with the entity's tax ID.
        """

        defmodule EntityValidationIssuesBeneficialOwnerAddress do
          @moduledoc """
          Details when the issue is with a beneficial owner's address.

          ## Fields

            * `beneficial_owner_id` - The ID of the beneficial owner.
            * `reason` - The reason the address is invalid.
          """

          defstruct [:beneficial_owner_id, :reason]

          @type t :: %__MODULE__{
                  beneficial_owner_id: String.t(),
                  reason: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              beneficial_owner_id: raw["beneficial_owner_id"],
              reason: raw["reason"]
            }
          end
        end

        defmodule EntityValidationIssuesBeneficialOwnerIdentity do
          @moduledoc """
          Details when the issue is with a beneficial owner's identity verification.

          ## Fields

            * `beneficial_owner_id` - The ID of the beneficial owner.
          """

          defstruct [:beneficial_owner_id]

          @type t :: %__MODULE__{
                  beneficial_owner_id: String.t()
                }

          @doc false
          @spec decode(map()) :: t()
          def decode(raw) when is_map(raw) do
            %__MODULE__{
              beneficial_owner_id: raw["beneficial_owner_id"]
            }
          end
        end

        defmodule EntityValidationIssuesEntityAddress do
          @moduledoc """
          Details when the issue is with the entity's address.

          ## Fields

            * `reason` - The reason the address is invalid.
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

        defmodule EntityValidationIssuesEntityTaxIdentifier do
          @moduledoc """
          Details when the issue is with the entity's tax ID.

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

        defstruct [
          :beneficial_owner_address,
          :beneficial_owner_identity,
          :category,
          :entity_address,
          :entity_tax_identifier
        ]

        @type t :: %__MODULE__{
                beneficial_owner_address: EntityValidationIssuesBeneficialOwnerAddress.t() | nil,
                beneficial_owner_identity:
                  EntityValidationIssuesBeneficialOwnerIdentity.t() | nil,
                category: String.t(),
                entity_address: EntityValidationIssuesEntityAddress.t() | nil,
                entity_tax_identifier: EntityValidationIssuesEntityTaxIdentifier.t() | nil
              }

        @doc false
        @spec decode(map()) :: t()
        def decode(raw) when is_map(raw) do
          %__MODULE__{
            beneficial_owner_address:
              Increase.Decode.struct(
                raw["beneficial_owner_address"],
                &EntityValidationIssuesBeneficialOwnerAddress.decode/1
              ),
            beneficial_owner_identity:
              Increase.Decode.struct(
                raw["beneficial_owner_identity"],
                &EntityValidationIssuesBeneficialOwnerIdentity.decode/1
              ),
            category: raw["category"],
            entity_address:
              Increase.Decode.struct(
                raw["entity_address"],
                &EntityValidationIssuesEntityAddress.decode/1
              ),
            entity_tax_identifier:
              Increase.Decode.struct(
                raw["entity_tax_identifier"],
                &EntityValidationIssuesEntityTaxIdentifier.decode/1
              )
          }
        end
      end

      defstruct [:issues, :status]

      @type t :: %__MODULE__{
              issues: [Issue.t()],
              status: String.t()
            }

      @doc false
      @spec decode(map()) :: t()
      def decode(raw) when is_map(raw) do
        %__MODULE__{
          issues: Increase.Decode.list(raw["issues"], &Issue.decode/1),
          status: raw["status"]
        }
      end
    end

    defstruct [
      :id,
      :corporation,
      :created_at,
      :creating_entity_onboarding_session_id,
      :description,
      :details_confirmed_at,
      :government_authority,
      :idempotency_key,
      :joint,
      :natural_person,
      :risk_rating,
      :status,
      :structure,
      :supplemental_documents,
      :terms_agreements,
      :third_party_verification,
      :trust,
      :type,
      :validation
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            corporation: Corporation.t() | nil,
            created_at: DateTime.t(),
            creating_entity_onboarding_session_id: String.t() | nil,
            description: String.t() | nil,
            details_confirmed_at: DateTime.t() | nil,
            government_authority: GovernmentAuthority.t() | nil,
            idempotency_key: String.t() | nil,
            joint: Joint.t() | nil,
            natural_person: NaturalPerson.t() | nil,
            risk_rating: RiskRating.t() | nil,
            status: String.t(),
            structure: String.t(),
            supplemental_documents: [
              Increase.SupplementalDocuments.EntitySupplementalDocument.t()
            ],
            terms_agreements: [TermsAgreement.t()],
            third_party_verification: ThirdPartyVerification.t() | nil,
            trust: Trust.t() | nil,
            type: String.t(),
            validation: Validation.t() | nil
          }

    @doc false
    @spec decode(map()) :: t()
    def decode(raw) when is_map(raw) do
      %__MODULE__{
        id: raw["id"],
        corporation: Increase.Decode.struct(raw["corporation"], &Corporation.decode/1),
        created_at: Increase.Decode.datetime(raw["created_at"]),
        creating_entity_onboarding_session_id: raw["creating_entity_onboarding_session_id"],
        description: raw["description"],
        details_confirmed_at: Increase.Decode.datetime(raw["details_confirmed_at"]),
        government_authority:
          Increase.Decode.struct(raw["government_authority"], &GovernmentAuthority.decode/1),
        idempotency_key: raw["idempotency_key"],
        joint: Increase.Decode.struct(raw["joint"], &Joint.decode/1),
        natural_person: Increase.Decode.struct(raw["natural_person"], &NaturalPerson.decode/1),
        risk_rating: Increase.Decode.struct(raw["risk_rating"], &RiskRating.decode/1),
        status: raw["status"],
        structure: raw["structure"],
        supplemental_documents:
          Increase.Decode.list(
            raw["supplemental_documents"],
            &Increase.SupplementalDocuments.EntitySupplementalDocument.decode/1
          ),
        terms_agreements: Increase.Decode.list(raw["terms_agreements"], &TermsAgreement.decode/1),
        third_party_verification:
          Increase.Decode.struct(
            raw["third_party_verification"],
            &ThirdPartyVerification.decode/1
          ),
        trust: Increase.Decode.struct(raw["trust"], &Trust.decode/1),
        type: raw["type"],
        validation: Increase.Decode.struct(raw["validation"], &Validation.decode/1)
      }
    end
  end

  @doc """
  Create an Entity

  `POST /entities`
  """
  @spec create(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Entity.t()} | {:error, Increase.Error.t()}
  def create(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entities"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Entity.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Retrieve an Entity

  `GET /entities/{entity_id}`
  """
  @spec retrieve(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Entity.t()} | {:error, Increase.Error.t()}
  def retrieve(client, entity_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/entities/#{entity_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :get, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Entity.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Update an Entity

  `PATCH /entities/{entity_id}`
  """
  @spec update(Increase.Client.t() | keyword() | nil, String.t(), map() | keyword(), keyword()) ::
          {:ok, Entity.t()} | {:error, Increase.Error.t()}
  def update(client, entity_id, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entities/#{entity_id}"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :patch, path,
           body: Map.new(params),
           idempotency_key: idempotency_key
         ) do
      {:ok, body} -> {:ok, Entity.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  List Entities

  Returns a `%Increase.Page{}` whose `data` is a list of `%__MODULE__.
  Entity{}` structs. Page through results with
  `Increase.Page.auto_paging_stream/1` or `Increase.Page.auto_paging_each/2`.

  `GET /entities`
  """
  @spec list(Increase.Client.t() | keyword() | nil, map() | keyword(), keyword()) ::
          {:ok, Page.t()} | {:error, Increase.Error.t()}
  def list(client, params \\ %{}, opts \\ []) do
    client = Client.resolve(client)

    path = "/entities"
    query = Map.new(params)

    fetch_next = fn cursor ->
      list(client, Map.put(query, :cursor, cursor), opts)
    end

    case Client.request(client, :get, path, query: query) do
      {:ok, body} -> {:ok, Page.new(body, fetch_next, &Entity.decode/1)}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Archive an Entity

  `POST /entities/{entity_id}/archive`
  """
  @spec archive(Increase.Client.t() | keyword() | nil, String.t(), keyword()) ::
          {:ok, Entity.t()} | {:error, Increase.Error.t()}
  def archive(client, entity_id, opts \\ []) do
    client = Client.resolve(client)

    path = "/entities/#{entity_id}/archive"
    idempotency_key = Keyword.get(opts, :idempotency_key)

    case Client.request(client, :post, path, idempotency_key: idempotency_key) do
      {:ok, body} -> {:ok, Entity.decode(body)}
      {:error, error} -> {:error, error}
    end
  end
end
