class Admin < Person
  after_destroy :atleast_one_admin_remains
  after_create :prevent_admin_creation_if_exists

  private
    def atleast_one_admin_remains
      raise "cant destroy all admins" unless Admin.all.count.zero?
    end

    def prevent_admin_creation_if_exists
      raise "only one admin can exist" if Admin.all.count == 2
    end
end