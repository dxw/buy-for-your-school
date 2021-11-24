require "csv"

# Capture user activity metrics
#
# @see RecordAction
class ActivityLogItem < ApplicationRecord
  self.table_name = "activity_log"

  default_scope { order(:created_at) }

  validates :user_id, :journey_id, :action, presence: true

  # @return [String]
  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << column_names

      find_each do |record|
        csv << record.attributes.values
      end
    end
  end
end
