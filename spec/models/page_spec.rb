RSpec.describe Page, type: :model do
  describe "attributes" do
    subject(:page) { create(:page) }

    it { is_expected.to be_persisted }

    it "requires a contentful_id" do
      expect { create(:page, contentful_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "requires unique contentful_id" do
      expect { create(:page, contentful_id: page.contentful_id) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
