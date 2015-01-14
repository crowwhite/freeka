FactoryGirl.define do

  factory :category_requirement do
    association :requirement, factory: :requirement
    association :category, factory: :category
  end

end