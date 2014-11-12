#Fixed -> Include secrets.yml.example file ?
#Fixed -> migration are giving error.
#Fixed -> Also update migrations as discussed.
#Fixed -> Add indexes as required.
class Admin < Person

  #Fixed -> Use before destroy, Conditions should fire only count query.
  before_destroy :atleast_one_admin_remains
  before_create :prevent_admin_creation_if_it_exists

  private
    def atleast_one_admin_remains
      raise "cant destroy all admins" if Admin.count == 1
    end

    def prevent_admin_creation_if_it_exists
      raise "only one admin can exist" if Admin.exists?
    end
end