FactoryGirl.define do

  sequence :email do |n|
    "test#{ n }@test.com"
  end

  factory :person do
    name 'test'
    email
    contact_no '9999999999'
    address 'some address'
    about_me 'I am a test person'
    password 'testtest'
    type 'User'

    trait :admin do
      type 'Admin'
    end

    factory :person_as_admin, traits: [:admin]
  end
end