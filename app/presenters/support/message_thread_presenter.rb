module Support
  class MessageThreadPresenter < BasePresenter
    # The recipients for all emails in a thread combined into one array
    #
    # @return [String]
    def recipients
      # group by email address in case there are multiple recipients with the same address
      # and prefer the one that has a proper name (rather than an email address for a name)
      grouped = Array(super)
        .group_by { |r| r["address"].downcase }
        .map { |_k, v|
          if v.size > 1
            v.filter { |r| !r["name"].include?("@") }
          else
            v
          end
        }.flatten
      resolve_name_from_case(grouped)
      # remove the shared mailbox name
      grouped.pluck("name").filter { |name| name != ENV["MS_GRAPH_SHARED_MAILBOX_NAME"] }.join(", ")
    end

    # @return [String]
    def last_updated
      super.strftime(date_format)
    end

    def messages
      super.includes([:in_reply_to]).map { |message| Support::Messages::OutlookMessagePresenter.new(message) }
    end

    def subject
      messages.first.subject
    end

    def case
      Support::CasePresenter.new(super)
    end

  private

    def date_format
      I18n.t("support.case.label.messages.table.date_format")
    end

    # check the recipients email against school contact email and get the contact name if available
    def resolve_name_from_case(recipients)
      return recipients if self.case.full_name.blank?

      matches = recipients.select { |r| r["address"].casecmp(self.case.email).zero? }
      matches.each { |m| m["name"] = self.case.full_name }
    end
  end
end
