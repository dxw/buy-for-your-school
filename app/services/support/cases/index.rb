module Support
  module Cases
    class Index
      def call
        # Support::Case.all
        mock_case_class = Struct.new(:id, :organisation, :status, :category, :assigned_to, :last_updated)

        [
          mock_case_class.new(1, 'St. Mary', 'NEW', 'MFD', 'John', 1.hour.ago),
          mock_case_class.new(2, 'Central', 'NEW', 'Catering', 'John', 1.year.ago)
        ]
      end
    end
  end
end