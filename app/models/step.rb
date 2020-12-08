class Step < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :journey

  has_one :radio_answer
  has_one :short_text_answer
  has_one :long_text_answer
  has_one :single_date_answer

  def radio_options
    options.map { |option| OpenStruct.new(id: option.downcase, name: option.titleize) }
  end

  def answer
    @answer ||=
      radio_answer ||
      short_text_answer ||
      long_text_answer ||
      single_date_answer
  end

  def question?
    contentful_model == "question"
  end

  def primary_call_to_action_text
    return I18n.t("generic.button.next") unless super.present?
    super
  end
end
