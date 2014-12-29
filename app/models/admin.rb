class Admin < Person
  before_destroy :atleast_one_admin_remains
  before_create :prevent_admin_creation_if_it_exists

  private
    def atleast_one_admin_remains
      if Admin.count == 1
        errors.add(:base, "cant destroy all admins")
        false
      end
    end

    def prevent_admin_creation_if_it_exists
      #FIXME_AB: Why can't we have two admins, was this a requirement?
      # Fixed: Yes, it was a requirement
      if Admin.exists?
        errors.add(:base, "only one admin can exist")
        false
      end
    end
end