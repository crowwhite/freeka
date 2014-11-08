class Person < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def self.types
    %w(Admin User)
  end

  def active_for_authentication?
    enabled? && super
  end

  def admin?
    type == 'Admin'
  end
end
