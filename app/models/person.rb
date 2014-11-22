class Person < ActiveRecord::Base

  TYPES = %w(Admin User)

  belongs_to :address
  has_many :requirements, foreign_key: :requestor_id
  has_many :donor_requirements, foreign_key: :donor_id
  has_many :donations, through: :donor_requirements, source: :requirement

  validates :name, :contact_no, presence: true
  validates :contact_no, numericality: true
  validates :type, inclusion: { in: TYPES, message: "%{ value } is not a valid type" }
  validate :no_spaces_in_password

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

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

  def no_spaces_in_password
    if password.include? ' '
      errors.add(:password, 'cannot contain white spaces')
    end
  end
end
