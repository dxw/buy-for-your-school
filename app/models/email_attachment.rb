class EmailAttachment < ApplicationRecord
  self.table_name = "support_email_attachments"

  include Cacheable
  # TODO: move these files
  include Support::EmailAttachment::DeDupable
  include Support::EmailAttachment::Hideable

  has_one_attached :file
  belongs_to :email

  scope :inline, -> { where(is_inline: true) }
  scope :non_inline, -> { where(is_inline: false) }
  scope :for_ticket, ->(ticket_id:) { joins(:email).where(email: { ticket_id: }) }

  def custom_name = super.presence || file_name
end
