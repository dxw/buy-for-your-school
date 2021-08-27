# TODO: replace this with an ActiveRecord model
# :nocov:
module Support
  class Interaction
    def self.all
      [find_by]
    end

    def self.find_by(_ignore = nil)
      OpenStruct.new(
        id: 1,
        name: 'foo',
        author: 'Cassius Clay',
        created_at: 3.hours.ago,
        problem_description: 'a',
        attached_specification: 'b',
        type: 'Ticket submission'
      )
    end
  end
end
# :nocov: