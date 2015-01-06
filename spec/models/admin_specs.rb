require 'rails_helper'

describe 'Admin' do

  describe 'creation of another admin' do
    before do
      admin = FactoryGirl.create(:admin)
      admin.update_column(:email, 'yy@test.com')
    end

    it 'raises exception' do
      expect { FactoryGirl.create(:admin) }.to raise_error
    end
  end

  describe 'destroying last admin type user' do
    before do
      admin = FactoryGirl.create(:admin)
    end
    it 'raises exception' do
      expect { admin.destroy }.to raise_error
    end
  end
end