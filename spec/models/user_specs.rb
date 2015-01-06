require 'rails_helper'

describe User do
  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_one(:image).dependent(:destroy).class_name(:Attachment) }
  end
end