#FIXME_AB: You should also have index on type and enabled column in db
# Fixed: I feel it should only be on enabled column since there is no search on type of user
class Person < ActiveRecord::Base

  TYPES = %w(Admin User)

  #FIXME_AB: What if I destroy this Person, what would happen to his associated records?
  # Fixed
  has_many :requirements, dependent: :destroy, foreign_key: :requestor_id
  #FIXME_AB: I am not sure about the following association name. please make 
  # Couldn't think of a better name
  has_many :donor_requirements, dependent: :destroy, foreign_key: :donor_id
  has_many :donations, through: :donor_requirements, dependent: :destroy, source: :requirement

  validates :name, :contact_no, presence: true
  # TODO: Use regexp to validate password.
  # Fixed
  #FIXME_AB: Lets make a constant RegExp hash in initializers to keep all regexp one place, so that we can resuse them.
  # Fixed
  #FIXME_AB: regexp should be extracted as constant hash so that can be reused. Something like REGEXP[:password] = /\S/
  #FIXME_AB: Also in FE we are not displaying that spaces are not allowed. How would user get to know about this.
  # Fixed
  validates :password, format: { with: VALIDATOR[:password], message: 'No white spaces allowed' }, on: :create
  #FIXME_AB: No max limit on contact number.
  # Fixed
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
