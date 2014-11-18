class User < Person
  devise :registerable
  scope :all_except_current, ->(id) { where.not(id: id) }
end
