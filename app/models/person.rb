class Person < ActiveRecord::Base

  TYPES = %w(Admin User)

  #FIXME_AB: What would happen to his associated records when a person is destroyed?
  has_many :requirements, foreign_key: :requestor_id
  has_many :donor_requirements, foreign_key: :donor_id
  has_many :donations, through: :donor_requirements, source: :requirement

  validates :name, :contact_no, presence: true
  # TODO: Use regexp to validate password.
  # Fixed
  #FIXME_AB: regexp should be extracted as constant hash so that can be reused. Something like REGEXP[:password] = /\S/
  #FIXME_AB: Also in FE we are not displaying that spaces are not allowed. How would user get to know about this.
  validates :password, format: { with: /\S/, message: 'No white spaces allowed' }, on: :create
  validates :contact_no, numericality: true, allow_blank: true
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

  def donor_requirement(requirement_id)
    #FIXME_AB: How about donor_requirements.where(:requirement_id, requirement_id)
    donor_requirements.find { |dr| dr.requirement_id == requirement_id }
  end

end
