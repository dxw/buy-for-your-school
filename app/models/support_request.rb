# A SupportRequest has and belongs to {User}
class SupportRequest < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :journey
end
