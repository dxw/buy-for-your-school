require "rails_helper"

describe "Agent can view notifications" do
  include_context "with an agent"

  it "displays the notifications" do
    support_notification = create(:support_notification, :case_assigned, assigned_to: agent)
    within("#navigation") { click_link "Notifications" }
    expect(page).to have_content("Assigned to case #{support_notification.support_case.ref}")
  end
end
