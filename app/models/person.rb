#FIXME_AB: You should also have index on type and enabled column in db
# Fixed: I feel it should only be on enabled column since there is no search on type of user
#FIXME_AB: Are you sure that there will be no search on type column. How would STI work then?
class Person < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  TYPES = %w(Admin User)

  has_many :requirements, dependent: :destroy, foreign_key: :requestor_id
  has_many :donor_requirements, dependent: :destroy, foreign_key: :donor_id
  has_many :donations, through: :donor_requirements, dependent: :destroy, source: :requirement

  validates :name, :contact_no, presence: true
  validates :password, format: { with: VALIDATOR[:password], message: 'No white spaces allowed' }, on: :create
  validates :contact_no, numericality: true, allow_blank: true
  validates :contact_no, length: { minimum: 10, maximum: 12 }
  validates :type, inclusion: { in: TYPES, message: "%{ value } is not a valid type" }
  #FIXME_AB: What about email validations?
  #FIXME_AB: Are we allowing special chars in name? We should have sensible validations on all models.

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # TODO: Why do we need this?
  # the devise tells us to define this
  def self.types
    TYPES
  end

  def active_for_authentication?
    enabled? && super
  end

  def admin?
    type == 'Admin'
  end

  def display_name
    name.capitalize
  end

end
