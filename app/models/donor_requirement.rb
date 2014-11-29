class DonorRequirement < ActiveRecord::Base
  include DonorRequirementASM

  enum status: { interested: 0, donated: 1, rejected: 2, current: 3 }

  belongs_to :user, foreign_key: :donor_id
  belongs_to :requirement

  after_create :update_requirement_status
  # TODO: What is zero??
  # Fixed -- it is changed to 2 now.. status integer for rejected
  after_create :make_current!, if: -> { DonorRequirement.where(requirement_id: requirement_id).where.not(status: 2).one? }
  before_destroy :prevent_if_fulfilled
  after_destroy :update_requirement_status, :update_donors

  def update_requirement_status
    # TODO: Refactor.
    if DonorRequirement.find_by(id: id)
      requirement.process! if requirement.may_process?
    else
      requirement.unprocess! if DonorRequirement.where(requirement_id: requirement.id).count.zero?
    end
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
    # TODO: Add errors
    # Fixed
    if requirement.fulfilled?
      errors.add(:base, 'You cannot remove interest from successful donation')
      false
    end
  end
end
