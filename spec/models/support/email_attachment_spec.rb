require "rails_helper"

RSpec.describe Support::EmailAttachment, type: :model do
  subject(:attachment) { build(:support_email_attachment) }

  it "updates the file_name attribute to match the file name" do
    attachment.save!

    expect(attachment.file_name).to eq("attachment.txt")
  end

  it "updates the file_type attribute to match the file type" do
    attachment.save!

    expect(attachment.file_type).to eq("text/plain")
  end

  it "updates the file_size attribute to match the file size" do
    attachment.save!

    expect(attachment.file_size).to eq(35)
  end

  describe ".import_attachment" do
    let(:email_attachment) { create(:support_email_attachment, outlook_id: "123") }
    let(:email) { email_attachment.email }

    let(:ms_attachment) do
      double(id: "123", content_bytes: "1024", name: "example_file.pdf")
    end

    before { allow(email).to receive(:attachments).and_return(double(find_or_initialize_by: email_attachment)) }

    it "imports the attachment" do
      allow(email_attachment).to receive(:import_from_ms_attachment)

      described_class.import_attachment(ms_attachment, email)

      expect(email_attachment).to have_received(:import_from_ms_attachment).with(ms_attachment).once
    end
  end

  describe "#import_from_ms_attachment" do
    let(:email_attachment) { build(:support_email_attachment, :without_file) }
    let(:ms_attachment) do
      double(id: "123", content_bytes: "SGVsbG8sIFdvcmxkCg==", name: "example_file.pdf", content_type: "text/plain")
    end

    it "attaches file from temp file" do
      email_attachment.import_from_ms_attachment(ms_attachment)

      expect(email_attachment.file.download).to eq("Hello, World\n")
      expect(email_attachment.file_name).to eq("example_file.pdf")
    end
  end
end
