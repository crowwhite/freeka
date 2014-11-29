class Admin < Person
  before_destroy :atleast_one_admin_remains
  before_create :prevent_admin_creation_if_it_exists

  private
    def atleast_one_admin_remains
      # TODO: Why raise ?
      raise "cant destroy all admins" if Admin.count == 1
    end

    def prevent_admin_creation_if_it_exists
      # TODO: Why raise ?
      raise "only one admin can exist" if Admin.exists?
    end
end