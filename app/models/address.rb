class Address < ActiveRecord::Base
  #FIXME_AB: Not sure why we need this address model and association with requirement. It should go in the requirement itself?
  has_many :requirements

  validates :city, :country_code, :state_code, presence: true
end
