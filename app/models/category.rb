class Category < ActiveRecord::Base
  scope :root, -> { where("parent_id is NULL").order(:name) }
  scope :enabled, -> { where("parent_id is NULL and enabled=true").order(:name) }

  has_many :sub_categories, class_name: Category, foreign_key: :parent_id,
    dependent: :restrict_with_error
  has_many :enabled_sub_categories, -> { where enabled: true }, class_name: Category,
    foreign_key: :parent_id
  belongs_to :parent_category, class_name: Category, foreign_key: :parent_id

  validates :sub_categories, absence: true, if: :parent_id, on: :update

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :parent_category, presence: true, if: :parent_id

  validate :ensure_parent_is_not_a_sub_category, if: :parent_id

  def parent?
    parent_id.nil?
  end

  private

    def prevent_if_children_exists
      raise 'cannot delete parent category if sub categories exists' unless sub_categories.count.zero?
    end

    def ensure_parent_is_not_a_sub_category
      errors.add(:parent_id, "category can't be a sub category") unless parent_category.parent_id.nil?
    end
end
