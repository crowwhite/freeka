class Category < ActiveRecord::Base
  has_many :sub_categories, :class_name => "Category", foreign_key: "parent_id"
  belongs_to :parent_category, :class_name => "Category", foreign_key: "parent_id"
  before_destroy :prevent_if_children_exists
  validate :prevent_parent_id_updation_if_children_exists, on: :update

  def prevent_if_children_exists
    raise 'cannot delete parent category' unless sub_categories.count.zero?
  end

  def prevent_parent_id_updation_if_children_exists
    if sub_categories.count > 0 && parent_id
      errors.add(:parent_id, " category can't change its parent since it has sub categories under it")
      false
    end
  end
end
