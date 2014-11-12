class Person < ActiveRecord::Base

  TYPES = %w(Admin User)

  validates :name, :email, :contact_no, :about_me, :address, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :contact_no, numericality: true
  validates :type, inclusion: { in: TYPES, message: "%{ value } is not a valid type" }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def self.types
    #Fixed -> CREATE a constant which contains this array.
    #TODO -> You have not used this array in all locations.
    #Fixed
    TYPES
  end

  def active_for_authentication?
    enabled? && super
  end

  def admin?
    type == 'Admin'
  end
end
