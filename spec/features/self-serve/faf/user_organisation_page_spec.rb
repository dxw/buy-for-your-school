RSpec.feature "Faf - user organisation page" do
  before do
    user_is_signed_in(user: user)
    visit "/procurement-support/new"
    find("label", text: "Yes, use my DfE Sign-in").click
    click_continue
    click_on "Yes, continue"
  end

  xcontext "when the user belongs to only one supported school" do
    let(:user) { create(:user, :one_supported_school) }

    it "skips step 3 because the school is implicit" do
      expect(page).not_to have_unchecked_field "Specialist School for Testing"
      expect(find("span.govuk-caption-l")).to have_text "About your request"
    end
  end

  xcontext "when the user belongs to multiple supported schools" do
    let(:user) { create(:user, :many_supported_schools) }

    it "loads the page" do
      expect(find("legend")).to have_text "Which school are you buying for?"
    end

    it "goes back to step 2 when the back link is clicked" do
      find(".govuk-back-link").click

      expect(find("h1")).to have_text "Is this your contact information?"
    end

    it "asks them to choose which school" do
      expect(page).to have_unchecked_field "Specialist School for Testing"
      expect(page).to have_unchecked_field "Greendale Academy for Bright Sparks"
    end

    it "requires a school be selected" do
      click_continue
      expect(find("h2.govuk-error-summary__title")).to have_text "There is a problem"
      expect(page).to have_link "You must select a school", href: "#framework-support-form-school-urn-field-error"
      expect(find(".govuk-error-message")).to have_text "You must select a school"
    end
  end
end
