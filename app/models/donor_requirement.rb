class DonorRequirement < ActiveRecord::Base
  include DonorRequirementASM

  enum status: { interested: 0, donated: 1, rejected: 2, current: 3 }

  belongs_to :user, foreign_key: :donor_id
  belongs_to :requirement

  after_create :update_requirement_status
  after_create :make_current, if: -> { DonorRequirement.where(requirement_id: requirement_id).one? }
  before_destroy :prevent_if_fulfilled
  after_destroy :update_requirement_status

  def update_requirement_status
    if DonorRequirement.find_by(id: id)
      requirement.process!
    else
      requirement.unprocess!
    end
  end

  def prevent_if_fulfilled
    !requirement.fulfilled?
  end
end
