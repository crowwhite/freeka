#FIXME_AB: Through out the application You haven't handled the dependent option with associations. Please do that as per the requirement.
class Requirement < ActiveRecord::Base
  #FIXME_AB: There are indexes missing on requirements table, Please add required indexes
  include AASM

  enum status: { pending: 0, fulfilled: 2 }

  # Association
  #FIXME_AB: Following two associations are wrong. We have a better way.
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
  # Fixed
  validates :title, presence: true
  validates :title, length: { minimum: 10 }
  #FIXME_AB: I guess following validation should be on create only
  # Fixed : It is needed in both create and update
  validate :date_not_in_past, unless: :status_changed?
  #FIXME_AB: Why do we have validations on only two fields?

  # Callbacks
  #FIXME_AB: before_destroy :check_destroyable. Such method name should be independent of states
  # Fixed
  before_destroy :check_destroyable
  before_update :prevent_if_interest_shown, unless: :status_changed?

  # Scopes
  scope :enabled, -> { where(enabled: true) }
  #FIXME_AB: I doubt if this is a right way of making scope, Is this scope chainable?
  # Fixed: Yes this is chainable
  #FIXME_AB: Ideally we should pass objects, in this case we should pass category object
  #FIXME_AB: Moreover I think we don't need following scope. Just have similar association in category like category.requirements
  scope :with_category, ->(category_id) { Category.find_by(id: category_id).requirements }
  #FIXME_AB: What is the meaning of following scope?
  scope :with_status_not, ->(status) { where.not(status: status) }
  #FIXME_AB: Use Time.current.to_date
  # Fixed
  scope :live, -> { where('expiration_date >= ?', Time.current.to_date) }

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :fulfilled

    event :fulfill do
      after do
        #FIXME_AB: Any better way to do this?
        # tobefixed
        comments.create(content: 'Requirement has been fulfilled. Thank You all.', user_id: requestor_id)
        thank_users
      end
      transitions from: :pending, to: :fulfilled
    end
  end

  private

    def thank_users
      #FIXME_AB: Lets us delayed job for sending emails
      # Fixed: implemented in different branch
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
    alias :check_destroyable :prevent_if_interest_shown

end
