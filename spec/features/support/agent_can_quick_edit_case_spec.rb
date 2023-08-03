require "rails_helper"

describe "Agent can quick edit a case", js: true do
  include_context "with an agent"

  let(:support_case) { create(:support_case, ref: "000001", agent:, support_level: :L1, category: gas_category, procurement_stage: need_stage) }

  before do
    define_basic_categories
    define_basic_procurement_stages
    support_case

    visit support_cases_path(anchor: "my-cases")
    within("#my-cases") { click_link "Quick edit" }
  end

  context "when changing the note, support level, stage, and 'with school' flag" do
    before do
      fill_in "Add a note to case 000001", with: "New note"
      choose "5 - DfE buying by getting quotes or bids"
      select "Tender preparation", from: "Procurement stage"
      choose "Yes"
      click_button "Save"
    end

    it "persists the changes" do
      expect(support_case.reload.interactions.note.first.body).to eq("New note")
      expect(support_case.reload.support_level).to eq("L5")
      expect(support_case.reload.procurement_stage.key).to eq("tender_preparation")
      expect(support_case.reload.with_school).to eq(true)
    end
  end
end
