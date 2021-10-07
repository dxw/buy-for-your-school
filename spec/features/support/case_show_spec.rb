RSpec.feature "Case Management Dashboard - show" do
  include_context "with an agent"

  let(:state) { "initial" }
  let(:support_case) { create(:support_case, state: state) }

  before do
    click_button "Agent Login"
    visit base_url
  end

  it "has 3 visible tabs" do
    expect(all(".govuk-tabs__list-item", visible: true).count).to eq(3)
  end

  it "defaults to the 'School details' tab" do
    expect(find(".govuk-tabs__list-item--selected")).to have_text "School details"
  end

  it "shows School details section" do
    within "#school-details" do
      expect(find(".govuk-summary-list")).to be_visible
    end
  end

  describe "Request details" do
    before { visit "#{base_url}#case-details" }

    it "lists request details" do
      within "#case-details" do
        expect(all(".govuk-summary-list__row")[0]).to have_text "Category"
        expect(all(".govuk-summary-list__row")[1]).to have_text "Description of problem"
        expect(all(".govuk-summary-list__row")[2]).to have_text "Attached specification"
      end
    end
  end

  describe "Case history" do
    before { visit "#{base_url}#case-history" }

    context "when currently assigned to a case owner" do
      before do
        agent = create(:support_agent)

        support_case.agent = agent
        support_case.save!

        # Refresh current page
        visit "#{base_url}#case-history"
      end

      it "shows a link to change case owner" do
        within "#case-history" do
          expect(find("p.govuk-body")).to have_text "Case owner: first_name last_name"
        end
      end
    end

    it "does not show a link to change case owner" do
      within "ul.case-actions" do
        expect(page).not_to have_selector("assign-owner")
      end
    end

    it "shows accordion with initial request for support" do
      within "#case-history" do
        expect(find(".govuk-accordion"))
          .to have_text "Request for support"
      end
    end
  end

  it "shows assign and resolve links" do
    within "ul.case-actions" do
      expect(page).to have_link "Assign to case worker"
      expect(page).to have_link "Resolve case"
    end
  end

  context "when the case is open" do
    let(:state) { "open" }

    it "shows the change owner link" do
      expect(find("a.change-owner")).to have_text "Change case owner"
    end

    it "shows the add note link" do
      expect(find("a.add-note")).to have_text "Add a case note"
    end

    it "shows the send email link" do
      expect(find("a.send-email")).to have_text "Send email"
    end

    it "show the log contact link" do
      expect(find("a.log-contact")).to have_text "Log contact with school"
    end
  end

  context "when the case is resolved" do
    let(:state) { "resolved" }

    it "shows the reopen case link" do
      expect(find("a.reopen")).to have_text "Reopen case"
    end
  end
end
