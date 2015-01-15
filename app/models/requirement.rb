#FIXME_AB: Through out the application You haven't handled the dependent option with associations. Please do that as per the requirement.
# Fixed
class Requirement < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessor :comment
  #FIXME_AB: There are indexes missing on requirements table, Please add required indexes to all tables as required
  # Fixed
  include AASM

  enum status: { pending: 0, fulfilled: 2 }

  # Association
  #FIXME_AB: Following two associations are wrong. We have a better way.
  has_one :image, -> { where(attacheable_sub_type: :Image) }, as: :attacheable, class_name: :Attachment, dependent: :destroy
  has_many :files, -> { where(attacheable_sub_type: :File) }, as: :attacheable, class_name: :Attachment, dependent: :destroy
  belongs_to :person, foreign_key: :requestor_id
  has_many :category_requirements, dependent: :destroy
  has_many :categories, through: :category_requirements
  has_many :donor_requirements, dependent: :destroy
  has_many :interested_donors, through: :donor_requirements, source: :user
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :files, allow_destroy: true, reject_if: proc { |attributes| !attributes[:attachment] }
  accepts_nested_attributes_for :image, allow_destroy: true

  # Validation
  validates :title, :details, :expiration_date, :city, :country_code, :state_code, presence: true
  validates :title, format: { with: VALIDATOR[:name], message: 'No special characters allowed' }
  validates :title, length: { minimum: 1 }
  validates :details, length: { minimum: 50 }
  validate :date_not_in_past, unless: :status_changed?
  #FIXME_AB: Why do we have validations on only two fields?

  # Callbacks
  before_destroy :check_destroyable
  before_update :prevent_if_interest_shown, unless: :status_changed?

  # Scopes
  scope :enabled, -> { where(enabled: true) }
  scope :title_like, ->(search_string) { where("title like %#{search_string}%")}
  #FIXME_AB: I doubt if this is a right way of making scope, Is this scope chainable?
  # Fixed: Yes this is chainable
  #FIXME_AB: Ideally we should pass objects, in this case we should pass category object
  #FIXME_AB: Moreover I think we don't need following scope. Just have similar association in category like category.requirements
  scope :with_category, ->(category_name) { Category.find_by(name: category_name).requirements }
  #FIXME_AB: What is the meaning of following scope?
  # executing not condition so not to select the requests with a particular status
  scope :with_status_not, ->(status) { where.not(status: status) }
  scope :live, -> { where('expiration_date >= ?', Time.current.to_date) }

  aasm column: :status, enum: true, whiny_transitions: false do
    state :pending, initial: true
    state :fulfilled

    event :fulfill do
      after do
        #FIXME_AB: Any better way to do this?
        # Fixed
        thank_users
      end
      transitions from: :pending, to: :fulfilled, guard: :add_comment_on_requirement
    end
  end

  private

    def add_comment_on_requirement
      unless comments.create(content: @comment, user_id: requestor_id).persisted?
        errors.add(:base, 'comment cannot be blank')
        false
      end
    end

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
    alias :check_destroyable :prevent_if_interest_shown

end
