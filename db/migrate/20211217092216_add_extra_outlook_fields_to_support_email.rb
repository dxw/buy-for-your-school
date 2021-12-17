class AddExtraOutlookFieldsToSupportEmail < ActiveRecord::Migration[6.1]
  def change
    add_column :support_emails, :outlook_id, :string
    add_column :support_emails, :outlook_conversation_id, :string
    add_column :support_emails, :is_read, :boolean, default: false
    add_column :support_emails, :is_draft, :boolean, default: false
    add_column :support_emails, :has_attachments, :boolean, default: false
    add_column :support_emails, :body_preview, :text
  end
end
