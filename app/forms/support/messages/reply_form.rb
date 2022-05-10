module Support
  class Messages::ReplyForm < Form
    extend Dry::Initializer
    include Concerns::ValidatableForm

    option :body, Types::Params::String, optional: true
    option :attachments, optional: true

    def reply_to_email(email, agent)
      email_body = Messages::Templates.new(params: { body: body, agent: agent.full_name }).call

      reply = Support::Messages::Outlook::SendReplyToEmail.new(
        reply_to_email: email,
        reply_text: email_body,
        sender: agent,
        file_attachments: file_attachments,
      )

      reply.call
    end

  private

    def file_attachments
      Array(attachments).map { |uploaded_file| Support::Messages::Outlook::Reply::FileAttachment.from_uploaded_file(uploaded_file) }
    end
  end
end
