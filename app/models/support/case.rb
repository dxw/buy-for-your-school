# TODO: replace this with an ActiveRecord model
# :nocov:
module Support
  class Case
    def self.all
      [find_by]
    end

    def self.find_by(_ignore = nil)
      OpenStruct.new(
        id: 1,
        organisation: 'St.Mary',
        state: 'new',
        category: 'CM Ticket',
        assigned_to: 'Mary Poppins',
        last_updated: 1.hour.ago,
        contact_name: 'John Lennon',
        contact_phone: '+44 777777777',
        contact_email: 'john@lennon.com',
        request_time: 2.hours.ago,
        history_events: Interaction.all
      )
    end
  end
end
# :nocov: