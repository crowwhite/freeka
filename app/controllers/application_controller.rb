class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # TODO: Move to respective controllers or a concern.
  def load_donations
    if current_user
      @donations = current_user.donations.all
    end
  end
end
