FactoryGirl.define do

  factory :requirement do
    title "this is factory generated requirement"
    details 'The length of the details for factory requirement should be atleast 50 characters'
    expiration_date Date.today
    country_code "IN"
    state_code "DL"
    city "New Delhi"
    status 0
    person
    enabled true

    trait :fulfilled do
      status 2
    end

    trait :disabled do
      enabled false
    end

    trait :past do
      expiration_date Date.today.ago(1.day)
    end

    trait :future do
      expiration_date Date.today.ago(-1.day)
    end

    factory :past_and_fulfilled_requirement, traits: [:fulfilled, :past]
    factory :future_requirement, traits: [:future]
    factory :disabled_requirement, traits: [:disabled]
  end
end