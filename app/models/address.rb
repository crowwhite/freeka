class Address < ActiveRecord::Base
  has_many :requirements, dependent: :restrict_with_error, foreign_key: :location_id
  #FIXME_AB: Not sure why we need this address model and association with requirement. It should go in the requirement itself?

  validates :city, :country_code, :state_code, presence: true
end
