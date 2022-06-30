RSpec.describe RequestPresenter do
  subject(:presenter) { described_class.new(support_request) }

  let(:support_request) { build(:support_request) }

  describe "#procurement_amount" do
    context "when there is a procurement_amount" do
      let(:support_request) { build(:support_request, procurement_amount: 54.55) }

      it "returns a formatted amount" do
        expect(presenter.procurement_amount).to eq "£54.55"
      end
    end

    context "when there is no procurement_amount" do
      context "and the request is not about a procurement" do
        let(:support_request) { build(:support_request, procurement_amount: nil, about_procurement: false) }

        it "returns a dash" do
          expect(presenter.procurement_amount).to eq "-"
        end
      end

      context "and the request is about a procurement" do
        let(:support_request) { build(:support_request, procurement_amount: nil, about_procurement: true) }

        it "returns 'Not known'" do
          expect(presenter.procurement_amount).to eq "Not known"
        end
      end
    end
  end

  describe "#confidence_level" do
    context "when there is a confidence_level" do
      let(:support_request) { build(:support_request, confidence_level: "somewhat_confident") }

      it "returns the string value" do
        expect(presenter.confidence_level).to eq "Somewhat confident"
      end
    end

    context "when there is no confidence_level" do
      let(:support_request) { build(:support_request, confidence_level: nil) }

      it "returns nil" do
        expect(presenter.confidence_level).to eq nil
      end
    end
  end

  describe "#special_requirements" do
    context "when there are special_requirements" do
      let(:support_request) { build(:support_request, special_requirements: "These are special requirements") }

      it "returns the string" do
        expect(presenter.special_requirements).to eq "These are special requirements"
      end
    end

    context "when there are no special_requirements" do
      let(:support_request) { build(:support_request, special_requirements: nil) }

      it "returns a dash" do
        expect(presenter.special_requirements).to eq "-"
      end
    end
  end
end