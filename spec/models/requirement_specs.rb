require 'rails_helper'

describe Requirement do
  describe 'associations' do
    it { should have_one(:image).conditions(attacheable_sub_type: :Image).class_name(:Attachment).dependent(:destroy) }
    it { should have_many(:files).conditions(attacheable_sub_type: :File).class_name(:Attachment).dependent(:destroy) }
    it { should belong_to(:person).with_foreign_key(:requestor_id) }
    it { should have_many(:category_requirements).dependent(:destroy) }
    it { should have_many(:categories).through(:category_requirements) }
    it { should have_many(:donor_requirements).dependent(:destroy) }
    it { should have_many(:interested_donors).through(:donor_requirements).source(:user) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:details) }
    it { should validate_presence_of(:expiration_date) }
    it { should validate_presence_of(:country_code) }
    it { should validate_presence_of(:state_code) }
    it { should allow_value('this is title').for(:title) }
    it { should_not allow_value('@this is title').for(:title) }
    it { should_not allow_value('this is title#').for(:title) }
    it { should_not allow_value('this is #title').for(:title) }
    it { should_not allow_value(Date.today.ago(1.day)).for(:expiration_date) }
    it { should ensure_length_of(:title).is_at_least(1) }
    it { should ensure_length_of(:details).is_at_least(50) }
  end

  describe 'scopes' do
    let!(:requirement) { FactoryGirl.create(:requirement) }
    let!(:future_requirement) { FactoryGirl.create(:future_requirement) }
    let!(:disabled_requirement) { FactoryGirl.create(:disabled_requirement) }
    let!(:expired_and_fulfilled_requirement) { FactoryGirl.create(:past_and_fulfilled_requirement) }
    describe '.live' do
      context 'should return only requests whose expiration_date has not passed' do
        let(:collection) { Requirement.live }
        it 'should include future requirement' do
          expect(collection.include?(future_requirement)).to eq(true)
        end
        it 'should include present requirement' do
          expect(collection.include?(requirement)).to eq(true)
        end
        it 'should not return past requirement' do
          expect(collection.include?(expired_and_fulfilled_requirement)).to eq(false)
        end
      end
    end

    describe '.with_status_not' do
      context 'when restricting fulfilled requirements' do
        it 'should return pending requirement' do
          expect(Requirement.with_status_not(Requirement.statuses[:fulfilled]).first).to eq(requirement)
        end
      end
      context 'when restricting pending requirements' do
        it 'should return fulfilled requirement' do
          expect(Requirement.with_status_not(Requirement.statuses[:pending]).first).to eq(expired_and_fulfilled_requirement) 
        end
      end
    end

    describe '.enabled' do
      context 'should return only enabled requirements' do
        let(:collection) { Requirement.enabled }
        it 'should should return only enabled requirement' do
          expect(collection.include?(requirement)).to eq(true)
          expect(collection.include?(future_requirement)).to eq(true)
          expect(collection.include?(expired_and_fulfilled_requirement)).to eq(true)
        end

        it 'should not return disabled requirement' do
          expect(collection.include?(disabled_requirement)).to eq(false)
        end
      end
    end

    describe '.with_category' do
      let!(:category) { FactoryGirl.create(:category) }
      let(:collection) { Requirement.with_category(category.name) }


      it 'should return objects of given category' do
        requirement.category_requirements.create(category_id: category.id)
        expect(collection.include?(requirement)).to eq(true)
      end

      it 'should not return objects not associated to given category' do
        expect(collection.include?(:future_requirement)).to eq(false)
      end
    end
  end

  describe '#add_comment_on_requirement' do
    let(:requirement) { FactoryGirl.create(:requirement) }

    before(:each) do
      Pusher.stub(:trigger)
      requirement.comment = 'rspec comment'
      expect(requirement.comments.size).to eq(0)
    end

    it 'should add comment to the requirement' do
      requirement.send(:add_comment_on_requirement)
      expect(requirement.comments.count).to eq(1)
    end

    it 'should return true if comment is added' do
      expect(requirement.send(:add_comment_on_requirement)).to eq(true)
      expect(requirement.comments.count).to eq(1)
    end

    it 'should return false if comment is not added' do
      requirement.comment = ''
      expect(requirement.send(:add_comment_on_requirement)).to eq(false)
      expect(requirement.comments.count).to eq(0)
    end

  end

  describe '#prevent_if_interest_shown' do
    let(:requirement) { FactoryGirl.create(:requirement) }

    it 'should return false if someone has shown interest' do
      requirement.donor_requirements.create(donor_id: 20)
      expect(requirement.send(:prevent_if_interest_shown)).to eq(false)
    end

    it 'should return true if none has shown interest' do
      expect(requirement.send(:prevent_if_interest_shown)).to eq(true)
    end
  end

end