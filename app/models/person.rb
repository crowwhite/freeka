#FIXME_AB: You should also have index on type and enabled column in db
class Person < ActiveRecord::Base

  TYPES = %w(Admin User)

  #FIXME_AB: What if I destroy this Person, what would happen to his associated records?
  has_many :requirements, foreign_key: :requestor_id
  #FIXME_AB: I am not sure about the following association name. please make 
  has_many :donor_requirements, foreign_key: :donor_id
  has_many :donations, through: :donor_requirements, source: :requirement

  validates :name, :contact_no, presence: true
  # TODO: Use regexp to validate password.
  # Fixed
  #FIXME_AB: Lets make a constant RegExp hash in initializers to keep all regexp one place, so that we can resuse them.
  validates :password, format: { with: /\S/, message: 'No white spaces allowed' }, on: :create
  #FIXME_AB: No max limit on contact number.
  validates :contact_no, numericality: true, allow_blank: true
  validates :type, inclusion: { in: TYPES, message: "%{ value } is not a valid type" }

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
