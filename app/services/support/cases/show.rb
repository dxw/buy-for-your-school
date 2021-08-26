module Support
  module Cases
    class Show
      private attr_reader :id

      def initialize(id:)
        @id = id
      end

      def call
        # Support::Case.find_by(id: id)
        mock_case_class = Struct.new(
          :id,
          :organisation,
          :status,
          :category,
          :assigned_to,
          :last_updated,
          :contact_name,
          :contact_phone,
          :contact_email,
          :request_time,
          :history_events
        )

        mock_history_event_class = Struct.new(
          :id,
          :name,
          :created_at,
          :problem_description,
          :attached_specification,
          :type
        )

        mock_case_class.new(
          1,
          'St. Mary',
          'NEW',
          'MFD',
          'John',
          1.hour.ago,
          'Mary Poppins',
          '+44 777888123',
          'mary@poppins.com',
          2.hour.ago,
          [
            mock_history_event_class.new(1, 'foo', 3.hours.ago, 'a', 'b', 'Ticket submission'),
            mock_history_event_class.new(2, 'bar', 4.hours.ago, 'a', 'b', 'Support ticket'),
            mock_history_event_class.new(3, 'baz', 5.hours.ago, 'a', 'b', 'Refund request')
          ]
        )
      end
    end
  end
end