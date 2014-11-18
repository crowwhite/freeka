class Person < ActiveRecord::Base

  TYPES = %w(Admin User)

  validates :name, :email, :contact_no, :about_me, :address, presence: true
  validates :email, uniqueness: { case_sensitive: false }
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

  def no_spaces_in_password
    if password.include? ' '
      errors.add(:password, 'cannot contain white spaces')
    end
  end
end
