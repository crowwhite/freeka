class WelcomeController < ApplicationController

  def index
    if current_admin
      redirect_to admins_welcome_path
    end
  end

  def admin_welcome
    unless current_admin
      flash[:notice] = "you are not authorised to view that page"
      redirect_to root_path
    end
  end
end