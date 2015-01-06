require 'rails_helper'

describe Address do
  describe 'associations' do
    it { should have_many(:requirements).with_foreign_key(:location_id) }
  end

  describe 'validations' do
    describe 'presence' do
      it { should validate_presence_of(:city) }
      it { should validate_presence_of(:state_code) }
      it { should validate_presence_of(:country_code) }
    end
  end
end