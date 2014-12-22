class WelcomeController < ApplicationController

  before_action :check_if_admin, only: :index

  def index
    #FIXME_AB: We have a better way to do the following, which would be more readable and less cryptic 
    @requirements = Requirement.enabled.live.with_status_not(Requirement.statuses[:fulfilled]).includes(:donor_requirements, :files).order(:expiration_date).page params[:page]
    render 'requirements/index'
  end

  private

    def check_if_admin
      if current_admin
        redirect_to admins_welcome_index_path
      end
    end

end