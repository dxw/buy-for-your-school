class Support::Case::Filtering
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor(
    :state,
    :category,
    :agent,
    :tower,
    :stage,
    :level,
    :has_org,
    :search_term,
    :procurement_stage,
    :sort_by,
    :sort_order,
  )

  validates :search_term,
            presence: true,
            length: { minimum: 2, message: "Search term must be at least 2 characters" },
            on: :searching

  def apply_to(cases)
    closed_cases_hidden_by_default(cases)
      .filtered_by(filtering_criteria)
      .sorted_by(sorting_criteria)
  end

  def filtering_criteria
    { state:, category:, agent:, tower:, stage:, level:, has_org:, search_term:, procurement_stage: }
  end

  def sorting_criteria
    { sort_by:, sort_order: }
  end

private

  def closed_cases_hidden_by_default(cases)
    return cases.not_closed unless Array(state).include?("closed") || search_term.present?

    cases
  end
end
