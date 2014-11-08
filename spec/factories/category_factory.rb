FactoryGirl.define do
  factory :parent_category, class: Category do
    name "test Category"
    parent_id nil
  end
end