require 'rails_helper'

describe Person do

  describe 'associations' do
    it { should have_many(:requirements).with_foreign_key(:requestor_id).dependent(:destroy) }
    it { should have_many(:donor_requirements).with_foreign_key(:donor_id).dependent(:destroy) }
    it { should have_many(:donations).through(:donor_requirements).dependent(:destroy).source(:requirement) }
  end

  describe 'validations' do
    describe 'presence' do
      describe 'name' do
        it { should validate_presence_of(:name) }
      end

      describe 'contact_no' do
        it { should validate_presence_of(:contact_no) }
      end
    end

    describe 'numericality test' do
      it { should validate_numericality_of(:contact_no) }
    end

    describe 'type of persons' do
      it { should validate_inclusion_of(:type).
        in_array(%w(Admin User)).
        with_message('%{ value } is not a valid type') }
    end
  end

  # describe 'is admin' do
  #   let(:person) { FactoryGirl.create(:person_as_admin) }
  #   context 'if type is admin' do
  #     it 'returns true' do
  #       expect(person.admin?).to be true
  #     end
  #   end

  #   context 'if type is other than admin' do
  #     before do
  #       person.type = 'User'
  #     end
  #     it 'returns false' do
  #       expect(person.admin?).to be false
  #     end
  #   end
  # end

end