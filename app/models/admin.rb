class Admin < Person
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