#FIXME_AB: Through out the application You haven't handled the dependent option with associations. Please do that as per the requirement.
class Requirement < ActiveRecord::Base
  #FIXME_AB: There are indexes missing on requirements table, Please add required indexes
  include AASM

  enum status: { pending: 0, fulfilled: 2 }

  # Association
  has_one :image, -> { where(attacheable_sub_type: :Image) }, as: :attacheable, class_name: :Attachment, dependent: :destroy
  has_many :files, -> { where(attacheable_sub_type: :File) }, as: :attacheable, class_name: :Attachment, dependent: :destroy
  belongs_to :address, foreign_key: :location_id, dependent: :destroy
  belongs_to :person, foreign_key: :requestor_id
  has_many :category_requirements, dependent: :destroy
  has_many :categories, through: :category_requirements
  has_many :donor_requirements, dependent: :destroy
  has_many :interested_donors, through: :donor_requirements, source: :user
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :files, allow_destroy: true
  accepts_nested_attributes_for :image, allow_destroy: true

  # Validation
  #FIXME_AB: I guess there should be a min length of title.
  validates :title, presence: true
  #FIXME_AB: I guess following validation should be on create only
  validate :date_not_in_past, unless: :status_changed?

  # Callbacks
  #FIXME_AB: before_destroy :check_destroyable. Such method name should be independent of states
  before_destroy :prevent_if_interest_shown
  before_update :prevent_if_interest_shown, unless: :status_changed?

  # Scopes
  scope :enabled, -> { where(enabled: true) }
  #FIXME_AB: I doubt if this is a right way of making scope, Is this scope chainable?
  scope :with_category, ->(category_id) { Category.find_by(id: category_id).requirements }
  scope :with_status_not, ->(status) { where.not(status: status) }
  #FIXME_AB: I would prefer to have an individual scope for every state. like Requirement.pending Requirement.fulfilled etc. This make it more readable.
  scope :with_status, ->(status) { where(status: status) }
  #FIXME_AB: Use Time.current.to_date
  scope :live, -> { where('expiration_date >= ?', Date.today)}

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :fulfilled

    event :fulfill do
      after do
        comments.create(content: 'Requirement has been fulfilled. Thank You all.', user_id: requestor_id)
        thank_users
      end
      transitions from: :pending, to: :fulfilled
    end
  end

  def donor_requirement(user_id)
    donor_requirements.find { |dr| dr.donor_id == user_id }
  end

  def donor
    donor_requirements.find(&:donated?).try(:user)
  end

  private

    def thank_users
      donor_requirements.interested.includes(:user).each do |donor_requirement|
        DonorMailer.thank_interested_donor(donor_requirement.user, self).deliver
      end
      donor_requirements.donated.includes(:user).each do |donor_requirement|
        DonorMailer.thank_fulfilling_donor(donor_requirement.user, self).deliver
      end
    end

    def date_not_in_past
      errors.add(:expiration_date, 'cannot be a past date') if expiration_date < Date.today
    end
  
    def prevent_if_interest_shown
      if donor_requirements.exists?
        errors.add(:base, 'Requirement cannot be destroyed or updated if users have shown interest.')
        false
      end
    end

end
