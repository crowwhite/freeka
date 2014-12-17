class User < Person
  devise :registerable

  scope :with_email_like, ->(email) { where("email LIKE CONCAT('%', ?, '%')", email) }
  scope :with_name_like, ->(name) { where("name LIKE CONCAT('%', ?, '%')", name) }
end
