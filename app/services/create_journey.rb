# CreateJourney service is responsible for constructing a {Journey} for the given user and category.
class CreateJourney
  attr_accessor :category_id, :user

  def initialize(category_id:, user:)
    self.category_id = category_id
    self.user = user
  end

  # Creates and persists a new Journey for the given category.
  #
  # This relies on additional services to construct the sections, tasks, and steps
  # within this journey.
  #
  # @see CreateSection
  # @see CreateTask
  # @see CreateStep
  #
  # @return [Journey]
  def call
    category = GetCategory.new(category_entry_id: category_id).call
    contentful_sections = GetSectionsFromCategory.new(category: category).call
    journey = Journey.new(
      category: category.title,
      contentful_id: category.id,
      user: user,
      started: true,
      last_worked_on: Time.zone.now,
      liquid_template: category.combined_specification_template,
    )

    journey.save!

    contentful_sections.each_with_index do |contentful_section, section_index|
      section = CreateSection.new(
        journey: journey,
        contentful_section: contentful_section,
        order: section_index,
      ).call

      contentful_tasks = GetTasksFromSection.new(section: contentful_section).call
      contentful_tasks.each_with_index do |contentful_task, task_index|
        task = CreateTask.new(
          section: section,
          contentful_task: contentful_task,
          order: task_index,
        ).call

        question_entries = GetStepsFromTask.new(task: contentful_task).call

        question_entries.each_with_index do |entry, question_index|
          CreateStep.new(
            contentful_entry: entry,
            task: task,
            order: question_index,
          ).call
        end
      end
    end

    journey
  end
end
