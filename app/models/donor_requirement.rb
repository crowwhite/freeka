class DonorRequirement < ActiveRecord::Base
  include AASM

  enum status: { interested: 0, donated: 1, rejected: 2, current: 3 }

  belongs_to :user, foreign_key: :donor_id
  belongs_to :requirement

  after_create :update_requirement_status
  after_create :make_current, if: -> { DonorRequirement.where(requirement_id: requirement_id).one? }
  before_destroy :prevent_if_fulfilled
  after_destroy :update_requirement_status

  aasm column: :status, enum: true do
    state :interested, initial: true
    state :donated
    state :rejected
    state :current

    event :donate do
      transitions from: :current, to: :donated
    end

    event :make_current do
      transitions from: :interested, to: :current
    end

    event :reject do
      transitions from: :current, to: :rejected
    end
  end

  def update_requirement_status
    if DonorRequirement.find_by(id: id)
      requirement.process!
    else
      requirement.unprocess!
    end
  end

  # def update_current_donor
  #   make_current if DonorRequirement.where(requirement_id: requirement_id).one?
  # end

  # def interested?
  #   status == 0
  # end

  # def donated?
  #   status == 1
  # end

  # def current?
  #   status == 3
  # end

  def prevent_if_fulfilled
    !requirement.fulfilled?
  end
end
