class Person < ActiveRecord::Base

  TYPES = %w(Admin User)

  has_many :requirements, foreign_key: :requestor_id
  has_many :donor_requirements, foreign_key: :donor_id
  has_many :donations, through: :donor_requirements, source: :requirement

  validates :name, :contact_no, presence: true
  # TODO: Use regexp to validate password.
  # Fixed
  validates :password, format: { with: /\S{6,15}/, message: 'No white spaces allowed' }, on: :create
  validates :contact_no, numericality: true
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

  def donor_requirement(requirement_id)
    donor_requirements.find { |dr| dr.requirement_id == requirement_id }
  end

end
