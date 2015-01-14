FactoryGirl.define do

  factory :donor_requirement do
    status 0
    association :user, factory: :person
  end

end