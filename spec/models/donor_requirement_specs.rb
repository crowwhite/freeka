require 'rails_helper'

describe DonorRequirement do
  describe 'associations' do
    it { should belong_to(:user).with_foreign_key(:donor_id) }
    it { should belong_to(:requirement) }
  end
end