require 'rails_helper'

describe Requirement do
  describe 'associations' do
    it { should have_one(:image).conditions(attacheable_sub_type: :Image).class_name(:Attachment).dependent(:destroy) }
    it { should have_many(:files).conditions(attacheable_sub_type: :File).class_name(:Attachment).dependent(:destroy) }
    it { should belong_to(:address).with_foreign_key(:location_id).dependent(:destroy) }
    it { should belong_to(:person).with_foreign_key(:requestor_id) }
    it { should have_many(:category_requirements).dependent(:destroy) }
    it { should have_many(:categories).through(:category_requirements) }
    it { should have_many(:donor_requirements).dependent(:destroy) }
    it { should have_many(:interested_donors).through(:donor_requirements).source(:user) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_at_least(10) }
  end
end