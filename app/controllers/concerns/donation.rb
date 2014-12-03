module Donation
  def load_donations
    if current_user
      @donations = current_user.donations.all
    end
  end
end