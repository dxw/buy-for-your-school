# @abstract Form Object for multi-step Find-a-Framework support questionnaire
#
class FafForm < Form
  # @!attribute [r] dsi
  # @return [Boolean]
  option :dsi, Types::Params::Bool, optional: true # 1

  # @!attribute [r] message_body
  # @see SupportRequest SupportRequest attributes
  # @return [String]
  option :message_body, optional: true # 5 (last)

  def to_h
    super.except(:dsi)
  end
end
