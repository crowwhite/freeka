class User < Person
  scope :all_except_current, ->(id) { where.not(id: id) }
end
