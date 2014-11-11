require 'rails_helper'

describe Category do
  describe 'relations' do
    it { should have_many(:sub_categories)}
  end

  describe 'relations' do
    it { should belong_to(:parent_category)}
  end

  describe 'validations' do
    describe 'presence of name' do
      it { should validate_presence_of(:name) }
    end
    
    describe 'uniqueness of name' do
      it { should validate_uniqueness_of(:name).case_insensitive }
    end
    describe 'validate parent category' do
      let(:category) { FactoryGirl.create(:category) }
      let!(:sub_category) { FactoryGirl.create(:category, name: 'sub_category', parent_id: category.id) }
      describe 'validate sub_categories' do
        # context 'parent id absent' do
        #   it { expect(category.sub_categories.to_a).not_to eq([]) }
        # end
        context 'parent id present' do
          before do
            category.update_column(:parent_id, 1)
            sub_category.update_column(:parent_id, nil)
          end
          it 'sub_categories should be []' do
            expect(category.sub_categories.to_a).to eq([])
          end
        end
      end

      describe 'validate parent category' do
        # let!(:category) { FactoryGirl.create(:category) }
        # let!(:sub_category) { FactoryGirl.create(:category, name: 'sub_category', parent_id: category.id) }
        context 'if parent_id is present in category creation' do
          it 'parent category should be present in database' do
            expect(sub_category.parent_category).to eq(category)
          end
        end
      end

      describe 'parent_category' do
        # let!(:category) { FactoryGirl.create(:category) }
        # let!(:sub_category) { FactoryGirl.create(:category, name: 'sub_category', parent_id: category.id) }
        it 'should not be a sub category' do
          expect { FactoryGirl.create(:category, name: 'sub_category2', parent_id: sub_category.id) }.to raise_error
        end
      end
    end
  end
end