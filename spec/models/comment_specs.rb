require 'rails_helper'

describe Comment do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:requirement) }
  end
end
