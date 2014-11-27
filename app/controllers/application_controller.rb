class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def load_donations
    if current_user
      @donations = current_user.donations.all
    end
  end
end
