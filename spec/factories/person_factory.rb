FactoryGirl.define do
  factory :person do
    name 'test'
    email 'test@test.com'
    contact_no '9999'
    address 'some address'
    about_me 'I am a test person'
    password 'testtest'

    trait :admin do
      type 'Admin'
    end

    factory :person_as_admin, traits: [:admin]
  end
end