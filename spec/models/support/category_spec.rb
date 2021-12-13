RSpec.describe Support::Category, type: :model do
  let(:support_category) { create(:support_category) }

  context "with cases" do
    let!(:support_case) { create(:support_case, category: support_category) }

    it "has case returned in collection" do
      expect(support_category.cases).not_to be_empty
      expect(support_category.cases.first.ref).to eql support_case.ref
    end
  end

  describe "validations" do
    context "with title" do
      it "is valid" do
        expect(support_category).to be_valid
      end
    end

    context "without title" do
      let(:support_category) { build(:support_category, title: nil) }

      it "is invalid" do
        expect(support_category).not_to be_valid
        expect(support_category.errors.full_messages).to include "Title can't be blank"
      end
    end
  end

  describe ".grouped_options" do
    context "with sub categories" do
      let(:parent_category) { create(:support_category, :with_sub_category) }

      it "returns nested hash" do
        expect(parent_category.class.grouped_opts).to be_categorised(parent: parent_category.title, child: parent_category.sub_categories.first.title)
      end
    end
  end
end
