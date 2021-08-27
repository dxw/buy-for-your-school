RSpec.feature "Supported Buying Proc-Ops Admin" do
  before do
    user_is_signed_in
    visit "/support/cases"
  end

  it do
    expect(page.title).to have_text "All cases"
  end

  it 'shows main heading' do
    expect(find("h1.govuk-heading-xl")).to have_text "Create a specification to procure catering for your school"
  end

end