class Category < ActiveRecord::Base

  attr_accessor :is_sub_category
  # TODO: Rename to `roots`
  # Fixed
  scope :roots, -> { where(parent_id: nil) }
  scope :with_status, ->(status) { where(enabled: status) }
  scope :enabled, -> { with_status(true) }
  scope :all_except, ->(id) { where.not(id: id) }
  scope :children, -> { where('parent_id IS NOT NULL') }

  # TODO: Fix indentation
  # Fixed
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
  validates :parent_id, presence: true, if: :is_sub_category
  validate :ensure_parent_is_not_a_sub_category, if: :parent_id

  after_update :toggle_status_of_sub_categories, if: :enabled_changed? && :is_parent?
  after_update :toggle_status_of_requirements, if: :enabled_changed?

  def is_parent?
    parent_id.nil?
  end

  def toggle_status_of_sub_categories
    # TODO: Optimize
    # Fixed
    sub_categories.update_all(enabled: enabled)
  end

  def toggle_status_of_requirements
    requirements.update_all(enabled: enabled)
  end

  private

    def ensure_parent_is_not_a_sub_category
      errors.add(:parent_id, "category can't be a sub category") unless parent_category.parent_id.nil?
    end
end
