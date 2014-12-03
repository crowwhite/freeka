class DonorRequirement < ActiveRecord::Base
  include AASM

  enum status: { interested: 0, donated: 1, rejected: 2, current: 3 }

  belongs_to :user, foreign_key: :donor_id
  belongs_to :requirement

  after_create :update_requirement_status_after_create
  # TODO: What is zero??
  # Fixed -- it is changed to 2 now.. status integer for rejected
  after_create :make_current!, if: -> { DonorRequirement.where(requirement_id: requirement_id).where.not(status: Requirement::STATUS[:fulfilled]).one? }
  before_destroy :prevent_if_fulfilled
  after_destroy :update_requirement_status_after_destroy, :update_donors

  aasm column: :status, enum: true do
    state :interested, initial: true
    state :donated
    state :rejected
    state :current

    event :donate do
      after do
        requirement.update_donor_and_reject_interested_donors

      end
      transitions from: :current, to: :donated
    end

    event :show_interest do
      transitions from: :rejected, to: :interested
    end

    event :make_current do
      transitions from: :rejected, to: :current
      transitions from: :interested, to: :current
    end

    event :reject do
      transitions from: :current, to: :rejected
      transitions from: :interested, to: :rejected
    end
  end

  def update_requirement_status_after_create
    # TODO: Refactor.
    # Fixed
    requirement.process! if requirement.may_process?
  end

  def update_requirement_status_after_destroy
    requirement.unprocess! unless DonorRequirement.exists?(requirement_id: requirement.id)
  end

  def update_donors
    donors = requirement.donor_requirements
    unless donors.detect(&:current?) || donors.detect(&:donated?)
      donors.sort_by(&:created_at).first.try(:make_current!)
      donors.each do |donor|
        donor.show_interest! if donor.may_show_interest?
      end
    end
  end

  def prevent_if_fulfilled
    if requirement.fulfilled?
      errors.add(:base, 'You cannot remove interest from successful donation')
      false
    end
  end
end
