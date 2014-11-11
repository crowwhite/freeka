class User < Person

  scope :all_except_current, -> { where.not(id: current_person.id) }
end
