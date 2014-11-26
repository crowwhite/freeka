class WelcomeController < ApplicationController

  def index
    if current_admin
      redirect_to admins_welcome_index_path
    else
      @requirements = Requirement.enabled.with_status_not(2).order(:expiration_date).page params[:page]
      render 'requirements/index'
    end
  end

end