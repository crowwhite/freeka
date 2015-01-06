require 'rails_helper'

describe CategoryRequirement do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should belong_to(:requirement) }
  end
end