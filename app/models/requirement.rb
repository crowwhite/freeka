class Requirement < ActiveRecord::Base

  STATUS = { 0 => 'Pending', 1 => 'In Process', 2 => 'Fulfilled' }

  belongs_to :address, foreign_key: :location_id
  belongs_to :person, foreign_key: :requestor_id
  has_many :category_requirements
  has_many :categories, through: :category_requirements
  has_many :donors, through: :donor_requirements, source: :user

  accepts_nested_attributes_for :address

  validates :title, presence: true

  before_destroy :allow_only_if_pending

  scope :enabled, -> { where(enabled: true)}

  def allow_only_if_pending
    status == 0
  end

  def toggle_interest(user_id)
    if record = DonorRequirement.find_by(requirement_id: id, donor_id: user_id)
      record.destroy
    else
      record = DonorRequirement.create(requirement_id: id, donor_id: user_id)
    end
  end

  def fulfill
    if status == 1
      update(status: 2)
    else
      false
    end
  end
end
