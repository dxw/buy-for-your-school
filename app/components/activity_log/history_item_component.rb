class ActivityLog::HistoryItemComponent < ViewComponent::Base
  renders_one :title
  renders_one :description

  def initialize(by:, date:, title: nil)
    @title = title
    @by    = by
    @date  = date
  end
end
