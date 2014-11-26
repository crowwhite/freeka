class Category < ActiveRecord::Base
  scope :root, -> { where("parent_id is NULL") }
  scope :with_status, ->(status) { where("enabled = ?", status) }
  scope :enabled, -> { with_status(true) }
  scope :all_except, ->(id) { where.not(id: id) }

  has_many :sub_categories, class_name: Category, foreign_key: :parent_id,
    dependent: :restrict_with_error
  has_many :enabled_sub_categories, -> { where enabled: true }, class_name: Category,
    foreign_key: :parent_id
  belongs_to :parent_category, class_name: Category, foreign_key: :parent_id
  has_many :requirements, through: :category_requirements, dependent: :restrict_with_error
  has_many :category_requirements, dependent: :restrict_with_error

  validates :sub_categories, absence: { message: 'should not exist for this category' }, if: :parent_id, on: :update
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :parent_category, presence: true, if: :parent_id
  validate :ensure_parent_is_not_a_sub_category, if: :parent_id

  after_update :toggle_status_of_sub_categories, if: :enabled_changed? && :is_parent?

  def is_parent?
    parent_id.nil?
  end

  def toggle_status_of_sub_categories
    sub_categories.with_status(!enabled?).each do |sub_category|
      sub_category.update_column(:enabled, enabled)
    end
  end

  private

    def prevent_if_children_exists
      raise 'cannot delete parent category if sub categories exists' unless sub_categories.count.zero?
    end

    def ensure_parent_is_not_a_sub_category
      errors.add(:parent_id, "category can't be a sub category") unless parent_category.parent_id.nil?
    end
end
