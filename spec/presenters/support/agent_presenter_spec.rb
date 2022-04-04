RSpec.describe Support::AgentPresenter do
  subject(:presenter) { described_class.new(agent) }

  let(:agent) { OpenStruct.new(first_name: "Ronald", last_name: "McDonald") }

  describe "#full_name" do
    it "joins first and last name" do
      expect(presenter.full_name).to eq("Ronald McDonald")
    end
  end

  describe "#guest?" do
    it "returns false" do
      expect(presenter.guest?).to be false
    end
  end

  describe "#as_json" do
    it "returns the full name" do
      expect(presenter.as_json).to include(
        "full_name" => "Ronald McDonald",
      )
    end
  end
end
