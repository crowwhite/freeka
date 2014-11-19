class CategoryRequirement < ActiveRecord::Base
  belongs_to :category
  belongs_to :requirement
end
