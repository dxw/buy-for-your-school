# Creates interaction
#
# Useful for creating an interaction
module Support
  module Concerns
    module CreateInteraction
      extend ActiveSupport::Concern

      def create_interaction(kase_id, event_type, body = "procurement updated", additional_data = nil)
        CreateInteraction.new(kase_id, event_type, current_agent.id, { body: body, additional_data: additional_data }.compact).call
      end
    end
  end
end