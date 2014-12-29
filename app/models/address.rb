class Address < ActiveRecord::Base
  #FIXME_AB: What about dependent option?
  has_many :requirements

  validates :city, :country_code, :state_code, presence: true
end
