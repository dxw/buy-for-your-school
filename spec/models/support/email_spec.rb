require "rails_helper"

RSpec.describe Support::Email, type: :model do
  subject(:email) { build(:support_email) }

  it { is_expected.to belong_to(:case).optional }

  context "when an email has not been assigned to a case" do
    it "does not create a new support interaction" do
      expect { email.save! }.to change { Support::Interaction.where(event_type: "email_from_school").count }.by(0)
    end
  end

  context "when an email has been assigned to a case" do
    it "does creates a new support interaction" do
      kase = create(:support_case)
      email.case = kase

      expect { email.save! }.to change { Support::Interaction.where(event_type: "email_from_school").count }.by(1)
    end
  end
end
