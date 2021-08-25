module Support
  module Cases
    class Show
      private attr_reader :id

      def initialize(id:)
        @id = id
      end

      def call
        # Support::Case.find_by(id: id)
        mock_case_class = Struct.new(:id, :organisation, :status, :category, :assigned_to, :last_updated)
        mock_case_class.new(1, 'St. Mary', 'NEW', 'MFD', 'John', 1.hour.ago)
      end
    end
  end
end