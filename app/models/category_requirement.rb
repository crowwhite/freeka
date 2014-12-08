#FIXME_AB: Shouldn't we have a simple HABTM association ?
class CategoryRequirement < ActiveRecord::Base
  belongs_to :category
  belongs_to :requirement
end
