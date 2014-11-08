require 'rails_helper'

describe Category do
  describe 'relations' do
    it { should have_many(:sub_categories)}
  end

  describe 'relations' do
    it { should belong_to(:parent_category)}
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
  end

  describe 'validation' do
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

#   describe 'validation' do
#     context 'validate sub_categories' do
#       let!(:category) { FactoryGirl.build(:parent_category) }
#       context 'parent id absent' do
#         #it { should validate_presence_of(category.sub_categories)}
#         it { expect(category.sub_categories).not_to be_nil }
#       end
#       context 'parent id present' do
#         before do
#           category.parent_id = 1
#         end
#         # @hh = category.sub_categories
#         # it { should validate_presence_of(@hh) }
#         it { expect(category.sub_categories).to eq([]) }
#       end
#     end
#   end
end