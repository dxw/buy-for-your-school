require "dry-initializer"

module Support
  # Track support case activity in controller actions
  #
  # @see Support::ActivityLogItem

  class RecordAction
    class UnexpectedActionType < StandardError; end
    extend Dry::Initializer

    # TODO: add RecordAction for change_service_level, change_state and close_case when
    # functionality has been added to the case controllers

    ACTION_TYPES = %w[
      open_case
      add_interaction
      change_category
      change_service_level
      change_state
      resolve_case
      close_case
    ].freeze

    # @!attribute action
    #   @return [String]
    option :action, Types::Strict::String.enum(*ACTION_TYPES)

    # @!attribute support_case_id
    #   @return [String]
    option :support_case_id, Types::String

    # @!attribute data
    #   @return [Hash]
    option :data, Types::Hash, default: proc { {} }

    # @return [Support::ActivityLogItem]
    def call
      Support::ActivityLogItem.create!(
        support_case_id: @support_case_id,
        action: @action,
        data: @data,
      )
    end
  end
end
