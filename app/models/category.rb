class Category < ActiveRecord::Base
  has_many :sub_categories, :class_name => "Category", foreign_key: "parent_id"
  belongs_to :parent_category, :class_name => "Category", foreign_key: "parent_id"
  before_destroy :prevent_if_children_exists
  validates :sub_categories, absence: true, if: :parent_id, on: :update
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :parent_category, presence: true, if: :parent_id
  validate :ensure_parent_is_not_a_sub_category, if: :parent_id

  private

    def prevent_if_children_exists
      raise 'cannot delete parent category if sub categories exists' unless sub_categories.count.zero?
    end

    def ensure_parent_is_not_a_sub_category
      errors.add(:parent_id, "category can't be a sub category") unless parent_category.parent_id.nil?
    end
end
