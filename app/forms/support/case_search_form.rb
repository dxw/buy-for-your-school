# frozen_string_literal: true

# :nocov:
module Support
  class CaseSearchForm
    extend Dry::Initializer
    include Concerns::ValidatableForm

    # @!attribute [r] search_term
    #   @return [String]
    option :search_term, Types::Params::String, optional: true

    def ransack_params
      { ref_or_organisation_urn_or_organisation_name_cont: search_term }
    end
  end
end
# :nocov:
