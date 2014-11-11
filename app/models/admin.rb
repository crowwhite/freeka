#TODO -> Include secrets.yml.example file ?
#TODO -> migration are giving error.
#TODO -> Also update migrations as discussed.
#TODO -> Add indexes as required.
class Admin < Person
  #TODO -> Use before destroy, Conditions should fire only count query.
  after_destroy :atleast_one_admin_remains
  before_create :prevent_admin_creation_if_it_exists

  private
    def atleast_one_admin_remains
      raise "cant destroy all admins" if Admin.count.zero?
    end

    def prevent_admin_creation_if_it_exists
      raise "only one admin can exist" if Admin.exists?
    end
end