#TODO -> migration are giving error.
#TODO -> Also update migrations as discussed.
#TODO -> Add indexes as required.
#Fixed -- tested too
class Admin < Person
  before_destroy :atleast_one_admin_remains
  before_create :prevent_admin_creation_if_it_exists

  private
    def atleast_one_admin_remains
      raise "cant destroy all admins" if Admin.count == 1
    end

    def prevent_admin_creation_if_it_exists
      #TODO -> Conditions should fire only count query.
      #Fixed -- exists seems more readable. otherwise any? and exists? are equivalent
      raise "only one admin can exist" if Admin.exists?
    end
end