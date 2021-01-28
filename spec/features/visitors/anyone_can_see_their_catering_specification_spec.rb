feature "Users can see their catering specification" do
  scenario "HTML" do
    stub_contentful_category(fixture_filename: "category-with-dynamic-liquid-template.json")
    visit root_path
    click_on(I18n.t("generic.button.start"))

    click_first_link_in_task_list

    choose("Catering")
    click_on(I18n.t("generic.button.next"))

    expect(page).to have_content(I18n.t("journey.specification.header"))

    within("article#specification") do
      expect(page).to have_content("Menus and ordering")
      expect(page).to have_content("Food standards")
      expect(page).to have_content("The school also requires the service to comply with the following non-mandatory food standards or schemes:")
      expect(page).to have_content("Catering")
    end
  end

  scenario "renders responses that need extra formatting" do
    stub_contentful_category(fixture_filename: "extended-radio-question.json")
    visit root_path
    click_on(I18n.t("generic.button.start"))

    click_first_link_in_task_list

    choose("Catering")
    fill_in "answer[further_information]", with: "The school needs the kitchen cleaned once a day"
    click_on(I18n.t("generic.button.next"))

    expect(page).to have_content(I18n.t("journey.specification.header"))

    within("article#specification") do
      expect(page).to have_content("Catering - The school needs the kitchen cleaned once a day")
    end
  end
end
