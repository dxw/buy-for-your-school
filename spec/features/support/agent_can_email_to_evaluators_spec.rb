require "rails_helper"

describe "Agent can email to evaluators", :js, :with_csrf_protection do
  include_context "with an agent"

  let(:support_case) { create(:support_case) }
  let(:file_1) { fixture_file_upload(Rails.root.join("spec/fixtures/support/text-file.txt"), "text/plain") }
  let(:file_2) { fixture_file_upload(Rails.root.join("spec/fixtures/support/another-text-file.txt"), "text/plain") }
  let(:document_uploader) { support_case.document_uploader(files: [file_1, file_2]) }

  specify "When add evaluators, set due date and upload documents status are not complete" do
    visit support_case_path(support_case, anchor: "tasklist")

    expect(find("#complete-evaluation-1-status")).to have_text("To do")
    expect(find("#complete-evaluation-2-status")).to have_text("To do")
    expect(find("#complete-evaluation-3-status")).to have_text("To do")
    expect(find("#complete-evaluation-4-status")).to have_text("Cannot start")
  end

  specify "When add evaluators or set due date or upload documents status are not complete" do
    support_case.update!(evaluation_due_date: Date.tomorrow)
    visit support_case_path(support_case, anchor: "tasklist")

    expect(find("#complete-evaluation-1-status")).to have_text("To do")
    expect(find("#complete-evaluation-2-status")).to have_text("Complete")
    expect(find("#complete-evaluation-3-status")).to have_text("To do")
    expect(find("#complete-evaluation-4-status")).to have_text("Cannot start")
  end

  specify "When add evaluators, set due date and upload documents status are complete" do
    support_case.update!(evaluation_due_date: Date.tomorrow, has_uploaded_documents: true)
    support_case.evaluators.create!(first_name: "Momo", last_name: "Taro", email: "email@address")
    document_uploader.save!
    create(:support_email_template, title: "Invitation to complete procurement evaluation", subject: "about energy", body: "energy body")
    support_case.reload

    visit support_case_path(support_case, anchor: "tasklist")

    expect(find("#complete-evaluation-4-status")).to have_text("To do")

    visit edit_support_case_email_evaluators_path(support_case)

    expect(page).to have_content("Email evaluators")

    create(:support_email, :inbox, ticket: support_case, outlook_conversation_id: "OCID1", subject: "Email Evaluators", recipients: [{ "name" => "Test 1", "address" => "test1@email.com" }], unique_body: "Email 1", is_read: false)
    support_case.update!(sent_email_to_evaluators: true)

    visit support_case_path(support_case, anchor: "tasklist")

    expect(find("#complete-evaluation-4-status")).to have_text("Complete")
  end
end