class User < Person
  devise :registerable

  validates :password, confirmation: true, on: :update, allow_blank: true
  validates :password_confirmation, presence: true, on: :update, allow_blank: true

  scope :with_email_like, ->(email) { where("email LIKE CONCAT('%', ?, '%')", email) }
  scope :with_name_like, ->(name) { where("name LIKE CONCAT('%', ?, '%')", name) }
end
