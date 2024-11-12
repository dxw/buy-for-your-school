require "rails_helper"

describe "Engagement Admin can create an Agent" do
  include_context "with an agent", roles: %w[e_and_o_admin]

  scenario "Engagement Admin creates a new agent and sets roles" do
    visit engagement_root_path
    click_on "Management"
    click_on "Agents"
    click_on "New Agent"
    fill_in "First name", with: "Abbey"
    fill_in "Last name", with: "Dale"
    fill_in "Email", with: "abbeydale@education.gov.uk"
    check "Engagement and Outreach Staff Member"
    click_on "Save"

    within "tr", text: "Abbey Dale" do
      expect(page).to have_content("Engagement and Outreach Staff Member")
    end
  end

  scenario "Admin with same email already exists" do
    agent = create(:support_agent, email: "abbeydale@education.gov.uk", roles: [])

    visit engagement_root_path
    click_on "Management"
    click_on "Agents"
    click_on "New Agent"
    fill_in "First name", with: "Abbey"
    fill_in "Last name", with: "Dale"
    fill_in "Email", with: "abbeydale@education.gov.uk"
    check "Engagement and Outreach Staff Member"
    click_on "Save"

    within "tr", text: "Abbey Dale" do
      expect(page).to have_content("Engagement and Outreach Staff Member")
    end

    agent.reload
    expect(agent).to have_attributes(
      first_name: "Abbey",
      last_name: "Dale",
      roles: %w[e_and_o],
    )
  end
end
