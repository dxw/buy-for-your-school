module Support
  class Messages::ReplyFormSchema < ::Support::Schema
    config.messages.top_namespace = :message_reply_form

    params do
      required(:body).value(:string)
      optional(:attachments)
    end

    rule(:body) do
      key(:body).failure(:missing) if value.blank?
    end

    rule(:attachments) do
      if value.present?
        all_files_safe = Array(value).all? { |upload_file| Support::VirusScanner.uploaded_file_safe?(upload_file) }
        key(:attachments).failure(:infected) unless all_files_safe

        all_files_allowed_type = Array(value).all? { |upload_file| upload_file.content_type.in?(OUTLOOK_MESSAGE_FILE_TYPE_ALLOW_LIST) }
        key(:attachments).failure(:incorrect_file_type) unless all_files_allowed_type
      end
    end
  end
end