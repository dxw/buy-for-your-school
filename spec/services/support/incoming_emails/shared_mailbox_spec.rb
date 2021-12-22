require "rails_helper"

describe Support::IncomingEmails::SharedMailbox do
  let(:graph_client) { double }

  describe ".synchronize" do
    let(:email_1) { double }
    let(:email_2) { double }

    before do
      allow_any_instance_of(described_class).to receive(:emails)
        .and_return([email_1, email_2])
    end

    it "converts each email into an Support::Email record" do
      allow(Support::Email).to receive(:from_message)

      described_class.synchronize(folder: :inbox)

      expect(Support::Email).to have_received(:from_message).with(email_1, folder: :inbox).once
      expect(Support::Email).to have_received(:from_message).with(email_2, folder: :inbox).once
    end
  end

  describe "#folder" do
    subject(:mailbox) { described_class.new(graph_client: double, folder: folder) }

    context "when initialized with inbox" do
      let(:folder) { :inbox }

      it "is SHARED_MAILBOX_FOLDER_ID_INBOX" do
        expect(mailbox.folder).to eq(SHARED_MAILBOX_FOLDER_ID_INBOX)
      end
    end

    context "when initialized with sent" do
      let(:folder) { :sent_items }

      it "is SHARED_MAILBOX_FOLDER_ID_SENT_ITEMS" do
        expect(mailbox.folder).to eq(SHARED_MAILBOX_FOLDER_ID_SENT_ITEMS)
      end
    end
  end

  describe "#emails" do
    subject(:mailbox) { described_class.new(graph_client: graph_client, folder: :inbox) }

    let(:graph_client) { double }
    let(:email) { double }

    before do
      allow(graph_client).to receive(:list_messages_in_folder)
        .with(SHARED_MAILBOX_USER_ID, SHARED_MAILBOX_FOLDER_ID_INBOX, query: anything)
        .and_return([email])
    end

    it "returns emails from the shared inbox" do
      expect(mailbox.emails).to eq([email])
    end

    context "when giving a custom date" do
      it "returns only emails sent at or after this date" do
        date = 1.week.ago

        mailbox.emails(since: date)

        expect(graph_client).to have_received(:list_messages_in_folder)
          .with(SHARED_MAILBOX_USER_ID, SHARED_MAILBOX_FOLDER_ID_INBOX, query: [
            "$filter=sentDateTime ge #{date.utc.iso8601}",
            "$orderby=sentDateTime asc",
          ])
      end
    end
  end
end
