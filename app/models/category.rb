class Category < ActiveRecord::Base
  #TODO -> Please give some space in associations and validations.
  has_many :sub_categories, :class_name => "Category", foreign_key: "parent_id"
  belongs_to :parent_category, :class_name => "Category", foreign_key: "parent_id"
  #TODO -> There is one option association to do this.
  before_destroy :prevent_if_children_exists
  #TODO -> I think these two validation are not required. Please check.
  validates :sub_categories, absence: true, if: :parent_id, on: :update
  validates :sub_categories, absence: true, if: :parent_id

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
