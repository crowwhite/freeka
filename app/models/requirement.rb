class Requirement < ActiveRecord::Base

  STATUS = { 0 => 'Pending', 1 => 'In Process', 2 => 'Fulfilled' }

  belongs_to :address, foreign_key: :location_id
  belongs_to :person, foreign_key: :requestor_id
  has_many :category_requirements
  has_many :categories, through: :category_requirements

  accepts_nested_attributes_for :address

  validates :title, presence: true

  before_destroy :allow_only_if_pending

  def allow_only_if_pending
    status == 0
  end
end
