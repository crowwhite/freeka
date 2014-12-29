class Address < ActiveRecord::Base
  #FIXME_AB: What about dependent option?
  # Fixed
  has_many :requirements, dependent: :restrict_with_error

  validates :city, :country_code, :state_code, presence: true
end
