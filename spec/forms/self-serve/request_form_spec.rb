RSpec.describe RequestForm do
  subject(:form) { described_class.new(user:) }

  let(:user) { create(:user) }

  describe "#confidence_levels" do
    it "returns the confidence level values" do
      expect(form.confidence_levels).to eq %w[very_confident confident slightly_confident somewhat_confident not_at_all_confident not_applicable]
    end
  end

  describe "#special_requirements_choice" do
    context "when there are validation errors" do
      subject(:form) { described_class.new(user:, special_requirements_choice: "yes", messages: { a: :b }) }

      it "returns the provided value" do
        expect(form.special_requirements_choice).to eq "yes"
      end
    end

    context "when there are no validation errors" do
      it "infers the choice from the special_requirements value" do
        form = described_class.new(user:, special_requirements: "reqs", messages: {})
        expect(form.special_requirements_choice).to eq "yes"

        form = described_class.new(user:, special_requirements: "", messages: {})
        expect(form.special_requirements_choice).to eq "no"
      end
    end
  end

  describe "#data" do
    it "excludes radio button choices" do
      form = described_class.new(user:, special_requirements_choice: "b")
      expect(form.data).not_to include "special_requirements_choice"
    end

    context "when procurement_amount is provided" do
      subject(:form) { described_class.new(user:, procurement_amount: "55.12") }

      it "includes the procurement amount" do
        expect(form.data[:procurement_amount]).to eq "55.12"
      end
    end

    context "when procurement_amount is not provided" do
      it "does not include procurement_amount" do
        expect(form.data).not_to include "procurement_amount"
      end
    end

    context "when confidence_level is provided" do
      subject(:form) { described_class.new(user:, confidence_level: "confident") }

      it "includes the confidence level" do
        expect(form.data[:confidence_level]).to eq "confident"
      end
    end

    context "when confidence_level is not provided" do
      it "does not include confidence_level" do
        expect(form.data).not_to include "confidence_level"
      end
    end
  end
end
