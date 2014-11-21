class DonorRequirement < ActiveRecord::Base
  belongs_to :person, foreign_key: :donor_id
  belongs_to :requirement

  after_create :update_requirement_status
  before_destroy :prevent_if_fulfilled
  after_destroy :update_requirement_status

  def update_requirement_status
    if DonorRequirement.find_by(id: id)
      requirement.update(status: requirement.status + 1)
    else
      requirement.update(status: requirement.status - 1)
    end
  end

  def prevent_if_fulfilled
    requirement.status != 2
  end
end
