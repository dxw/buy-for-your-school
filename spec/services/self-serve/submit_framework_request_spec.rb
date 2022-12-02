require "rails_helper"

describe SubmitFrameworkRequest do
  let(:email_confirmation) { double(call: true) }
  let(:request) { create(:framework_request, message_body: "An energy case", energy_alternative:) }
  let(:referrer) { nil }
  let(:energy_alternative) { nil }
  let(:category_detection_results) { [] }
  let(:email_confirmation_parameters) { anything }

  before do
    allow(Emails::Confirmation).to receive(:new).with(email_confirmation_parameters).and_return(email_confirmation)
    allow(Support::CategoryDetection).to receive(:results_for).with("An energy case", anything).and_return(category_detection_results)
  end

  describe "#call" do
    context "when a category can be detected for the given request text" do
      let(:electricity) { create(:support_category, title: "Electricity") }
      let(:category_detection_results) { [Support::CategoryDetection.new(category_id: electricity.id)] }

      it "sets that category on the new case" do
        described_class.new(request:, referrer:).call
        expect(Support::Case.last.category).to eq(electricity)
      end
    end

    context "when a category cannot be detected for the given request text" do
      let(:category_detection_results) { [] }

      it "the case category remains nil" do
        described_class.new(request:, referrer:).call
        expect(Support::Case.last.category).to be_nil
      end
    end

    context "when it's an energy request" do
      let(:energy_alternative) { :email_later }

      it "sends out the confirmation email for energy requests" do
        allow(Emails::ConfirmationEnergy).to receive(:new).with(email_confirmation_parameters).and_return(email_confirmation)
        described_class.new(request:, referrer:).call
      end
    end

    context "when energy bills have been uploaded" do
      let!(:bill_1) { create(:energy_bill, :pending, framework_request: request) }
      let!(:bill_2) { create(:energy_bill, :pending, framework_request: request) }

      it "sets their status to submitted" do
        described_class.new(request:, referrer:).call

        expect(bill_1.reload).to be_submitted
        expect(bill_2.reload).to be_submitted
      end

      it "connects them with the newly created case" do
        described_class.new(request:, referrer:).call

        expect(bill_1.reload.support_case).to eq(Support::Case.last)
        expect(bill_2.reload.support_case).to eq(Support::Case.last)
      end
    end
  end
end
