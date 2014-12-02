class Requirement < ActiveRecord::Base
  include AASM

  enum status: { pending: 0, in_process: 1, fulfilled: 2 }

  

  belongs_to :address, foreign_key: :location_id
  belongs_to :person, foreign_key: :requestor_id
  has_many :category_requirements
  has_many :categories, through: :category_requirements
  has_many :donor_requirements
  has_many :interested_donors, through: :donor_requirements, source: :user

  accepts_nested_attributes_for :address

  validates :title, presence: true
  validate :date_not_in_past

  before_destroy :prevent_if_not_pending

  scope :enabled, -> { where(enabled: true) }
  scope :with_category, ->(category_id) { Category.find_by(id: category_id).requirements }
  scope :with_status_not, ->(status) { where.not(status: status) }
  scope :with_status, ->(status) { where(status: status) }

  aasm column: :status, enum: true, whiny_transitions: false do
    state :pending, initial: true
    state :in_process
    state :fulfilled

    event :process do
      transitions from: :pending, to: :in_process
    end

    event :unprocess do
      transitions from: :in_process, to: :pending
    end

    event :fulfill do
      after do
        # TODO: Module should never be dependent on including classes.
        # Fixed
        update_donor_and_reject_interested_donors
      end
      before do
        !pending?
      end
      transitions from: :in_process, to: :fulfilled
    end
  end

  def donor_requirement(user_id)
    donor_requirements.find { |dr| dr.donor_id == user_id }
  end

  def donor
    donor_requirements.find(&:donated?).try(:user)
  end

  def reject_current_donor
    donor_requirements.find(&:current?).reject!
    if donor = donor_requirements.sort_by(&:created_at).find(&:interested?)
      donor.make_current!
    else
      unprocess!
    end
  end

  def donate
    donor_requirements.find(&:current?).donate!
  end

  def update_donor_and_reject_interested_donors
    donor_requirements.each do |donor_requirement|
      if donor_requirement.interested?
        donor_requirement.reject!
      elsif donor_requirement.current?
        donor_requirement.donate!
      end
    end
  end

  private

    def date_not_in_past
      errors.add(:expiration_date, 'cannot be a past date') if expiration_date < Date.today
    end
  # TODO: Is this working?
  # Fixed
    def prevent_if_not_pending
      if !pending?
        errors.add(:status, 'Cannot be destroyed or updated in -in process- or -fulfilled- state')
        false
      end
    end

end
