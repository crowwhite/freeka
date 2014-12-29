#FIXME_AB: Shouldn't we have a simple HABTM association ?
# Fixed: We donot use HABTM unless we are 100% sure that it won't be needed as a model later
class CategoryRequirement < ActiveRecord::Base
  belongs_to :category
  belongs_to :requirement
end
