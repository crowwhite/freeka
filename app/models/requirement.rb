class Requirement < ActiveRecord::Base

  STATUS = { 0 => 'Pending', 1 => 'In Process', 2 => 'Fulfilled' }

  belongs_to :address, foreign_key: :location_id
  belongs_to :person, foreign_key: :requestor_id
  has_many :category_requirements
  has_many :categories, through: :category_requirements
  has_many :donor_requirements
  has_many :interested_donors, through: :donor_requirements, source: :user

  accepts_nested_attributes_for :address

  validates :title, presence: true

  before_destroy :pending?

  scope :enabled, -> { where(enabled: true) }

  def donor_requirement(user_id)
    donor_requirements.find { |dr| dr.donor_id == user_id }
  end

  def pending?
    status == 0
  end

  def in_process?
    status == 1
  end

  def fulfilled?
    status == 2
  end

  def toggle_interest(user_id)
    if record = DonorRequirement.find_by(requirement_id: id, donor_id: user_id)
      record.destroy
    else
      record = DonorRequirement.create(requirement_id: id, donor_id: user_id)
    end
  end

  def fulfill
    if in_process?
      update(status: 2)
      update_donor_and_reject_interested_donors
    else
      false
    end
  end

  def donor
    donor_requirements.find(&:donated?).try(:user)
  end

  def reject_current_donor
    donor_requirements.find(&:current?).update(status: 2)
    donor_requirements.sort_by(&:created_at).first.update(status: 3)
  end

  private
    def update_donor_and_reject_interested_donors
      donor_requirements.each do |donor_requirement|
        if donor_requirement.interested?
          donor_requirement.update_column(:status, 2) # 2=> rejected
        elsif donor_requirement.current?
          donor_requirement.update_column(:status, 1) # 1=> donated
        end
      end
    end
end
