RSpec.feature "NextStepsMFD" do
  before do
    Page.create!(
      title: "Next Steps",
      slug: "next_steps_mfd",
      body: File.read("config/static/next_steps_mfd.md"),
    )
    visit "/next-steps-mfd"
  end

  describe "body" do
    scenario "contains the expected content regarding next steps" do
      expect(page).to have_text("Next steps")
      expect(page).to have_title("Next Steps")
    end
  end
end
