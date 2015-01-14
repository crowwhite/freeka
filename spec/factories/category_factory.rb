FactoryGirl.define do

  sequence :name do |n|
    "test Category #{ n }"
  end

  factory :category do
    name
  end
end