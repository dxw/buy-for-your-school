RSpec.describe Support::CasePresenter do
  subject(:presenter) { described_class.new(support_case) }

  let(:agent) { create(:support_agent) }
  let(:organisation) { create(:support_organisation, urn: "000000", name: "Example Org") }
  let(:support_case) do
    create(:support_case,
           agent: agent,
           organisation: organisation,
           created_at: Time.zone.local(2021, 1, 30, 12, 0, 0))
  end

  before do
    create(:support_interaction, case: support_case, created_at: Time.zone.local(2021, 1, 31, 12, 0, 0))
  end

  describe "#state" do
    it "is uppercase" do
      expect(presenter.state).to eq("INITIAL")
    end
  end

  describe "#agent_name" do
    # TODO: possible context where we render "UNASSIGNED" or similar?
    it "returns the name of the agent that's assigned to the case" do
      expect(presenter.agent_name).to eq("first_name last_name")
    end
  end

  describe "#received_at" do
    it "returns the formatted date on which the case was received" do
      expect(presenter.received_at).to eq("30 January 2021 at 12:00")
    end
  end

  describe "#last_updated_at" do
    it "returns the formatted date on which the case was last updated" do
      expect(presenter.last_updated_at).to eq("31 January 2021 at 12:00")
    end
  end

  describe "#interactions" do
    it "is decorated" do
      expect(presenter.interactions.first).to be_a(Support::InteractionPresenter)
    end
  end

  describe "#category" do
    it "is decorated" do
      expect(presenter.category).to be_a(Support::CategoryPresenter)
    end
  end

  describe "#organisation" do
    it "is decorated" do
      expect(presenter.organisation).to be_a(Support::OrganisationPresenter)
    end
  end

  describe "#org_name" do
    it "returns org name" do
      expect(presenter.org_name).to eq "Example Org"
    end
  end

  describe "#org_urn" do
    it "returns org urn" do
      expect(presenter.org_urn).to eq "000000"
    end
  end
end
