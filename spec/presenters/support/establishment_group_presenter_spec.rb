RSpec.describe Support::EstablishmentGroupPresenter do
  subject(:presenter) { described_class.new(establishment_group) }

  context "with address defined" do
    let(:establishment_group) { create(:support_establishment_group, :with_address) }

    describe "#formatted_address" do
      it "returns a correctly address formatted" do
        expect(presenter.formatted_address).to eq("Boundary House Shr, 91 Charter House Street, EC1M 6HR")
      end
    end
  end

  context "with no address defined" do
    let(:establishment_group) { create(:support_establishment_group, :with_no_address) }

    describe "#formatted_address" do
      it "returns a correctly address formatted" do
        expect(presenter.formatted_address).to eq ""
      end
    end
  end
end
