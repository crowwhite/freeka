class DonorRequirement < ActiveRecord::Base

  STATUS = { 0 => 'Interested', 1 => 'Donated', 2 => 'Rejected', 3 => 'Current' }

  belongs_to :user, foreign_key: :donor_id
  belongs_to :requirement

  after_create :update_requirement_status, :update_current_donor
  before_destroy :prevent_if_fulfilled
  after_destroy :update_requirement_status

  def update_requirement_status
    if DonorRequirement.find_by(id: id)
      requirement.update(status: requirement.status + 1)
    else
      requirement.update(status: requirement.status - 1)
    end
  end

  def update_current_donor
    update(status: 3) if DonorRequirement.where(requirement_id: requirement_id).one?
  end

  def interested?
    status == 0
  end

  def donated?
    status == 1
  end

  def current?
    status == 3
  end

  def prevent_if_fulfilled
    !requirement.fulfilled?
  end
end
