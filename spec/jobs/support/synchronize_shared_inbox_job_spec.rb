require "rails_helper"

describe Support::SynchronizeSharedInboxJob do
  subject(:job) { described_class.new }

  describe "#perform" do
    it "synchronizes emails from the last 4 minutes with the shared mailbox inbox folder" do
      allow(Support::IncomingEmails::SharedMailbox).to receive(:synchronize)

      job.perform

      expect(Support::IncomingEmails::SharedMailbox).to have_received(:synchronize)
        .with(emails_since: be_within(1.second).of(4.minutes.ago), folder: :inbox).once
    end

    it "synchronizes emails from the last 4 minutes with the shared mailbox sent messages folder" do
      allow(Support::IncomingEmails::SharedMailbox).to receive(:synchronize)

      job.perform

      expect(Support::IncomingEmails::SharedMailbox).to have_received(:synchronize)
        .with(emails_since: be_within(1.second).of(4.minutes.ago), folder: :sent_items).once
    end
  end
end
