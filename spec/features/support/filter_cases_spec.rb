RSpec.feature "Filter cases", bullet: :skip, js: true do
  include_context "with an agent"

  let(:catering_cat) { create(:support_category, title: "Catering") }
  let(:mfd_cat) { create(:support_category, title: "MFD") }
  let(:agent) { create(:support_agent, first_name: "Example Support Agent") }

  before do
    create_list(:support_case, 10)
    create(:support_case, category: catering_cat)
    create(:support_case, category: mfd_cat, state: :on_hold)
    create(:support_case, category: mfd_cat, state: :opened)
    create(:support_case, agent:)
    create(:support_case, state: :closed)
    click_button "Agent Login"
  end

  describe "case filtering" do
    it "filters by category" do
      click_link "All cases"
      within "#all-cases" do
        click_button "Filter results"
        find("#filter-all-cases-form-category-field").find(:option, "Catering").select_option
        click_button "Apply filter"
        expect(all(".govuk-table__body .govuk-table__row").count).to eq(2)
        row = all(".govuk-table__body .govuk-table__row")
        expect(row[0]).to have_text "Catering"
      end
    end

    it "filters by agent" do
      click_link "All cases"
      within "#all-cases" do
        click_button "Filter results"
        find("#filter-all-cases-form-agent-field").find(:option, "Example Support Agent").select_option
        click_button "Apply filter"
        expect(all(".govuk-table__body .govuk-table__row").count).to eq(2)
        row = all(".govuk-table__body .govuk-table__row")
        expect(row[0]).to have_text "Example Support Agent"
      end
    end

    it "filters by state" do
      click_link "All cases"
      within "#all-cases" do
        click_button "Filter results"
        find("#filter-all-cases-form-state-field").find(:option, "Closed").select_option
        click_button "Apply filter"
        expect(all(".govuk-table__body .govuk-table__row").count).to eq(2)
        row = all(".govuk-table__body .govuk-table__row")
        expect(row[0]).to have_text "Closed"
      end
    end
  end

  describe "case sorting" do
    it "sorts by agent" do
      click_link "All cases"
      within "#all-cases" do
        click_button "Assigned"
        expect(all(".govuk-table__body .govuk-table__row").count).to eq(20)
        row = all(".govuk-table__body .govuk-table__row")
        expect(row[0]).to have_text "Example Support Agent"
      end
    end
  end

  describe "case filtering and sorting" do
    it "filters by category and sorts by state" do
      click_link "All cases"
      within "#all-cases" do
        click_button "Filter results"
        find("#filter-all-cases-form-category-field").find(:option, "MFD").select_option
        click_button "Apply filter"
        click_button "Status"
        expect(all(".govuk-table__body .govuk-table__row").count).to eq(4)
        row = all(".govuk-table__body .govuk-table__row")
        expect(row[0]).to have_text "On Hold"
      end
    end
  end
end
