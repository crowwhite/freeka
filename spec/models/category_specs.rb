require 'rails_helper'

describe Category do
  let(:category) { FactoryGirl.create(:category) }
  let!(:sub_category) { FactoryGirl.create(:category, name: 'sub_category', parent_id: category.id) }
  describe 'relations' do
    it { should have_many(:sub_categories) }
    it { should have_many(:enabled_sub_categories) }
    it { should belong_to(:parent_category) }
    it { should have_many(:category_requirements).dependent(:restrict_with_error) }
    it { should have_many(:requirements).through(:category_requirements).dependent(:restrict_with_error) }
  end


  describe 'validations' do
    describe 'presence of name' do
      it { should validate_presence_of(:name) }
    end
    
    describe 'uniqueness of name' do
      it { should validate_uniqueness_of(:name).case_insensitive }
    end
    describe 'validate parent category' do
      describe 'validate sub_categories' do
        context 'parent id absent' do
          it { expect(category.sub_categories.to_a).not_to eq([]) }
        end
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
        context 'if parent_id is present in category creation' do
          it 'parent category should be present in database' do
            expect(sub_category.parent_category).to eq(category)
          end
        end
      end

      describe 'parent_category' do
        it 'should not be a sub category' do
          expect { FactoryGirl.create(:category, name: 'sub_category2', parent_id: sub_category.id) }.to raise_error
        end
      end
    end
  end

  describe '#is_parent?' do
    context 'when called on a parent category' do
      it 'should return true' do
        expect(category.is_parent?).to eq(true)
      end
    end
  end
end