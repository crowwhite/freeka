class Admin < Person
  before_destroy :atleast_one_admin_remains
  before_create :prevent_admin_creation_if_it_exists

  private
    def atleast_one_admin_remains
      # TODO: Why raise ?
      # Fixed
      if Admin.count == 1
        errors.add(:base, "cant destroy all admins")
        false
      end
    end

    def prevent_admin_creation_if_it_exists
      # TODO: Why raise ?
      # Fixed
      if Admin.exists?
        errors.add(:base, "only one admin can exist")
        false
      end
    end
end