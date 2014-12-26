class WelcomeController < ApplicationController

  before_action :check_if_admin, only: :index

  def index
    @requirements = Requirement.enabled.live.with_status_not(Requirement.statuses[:fulfilled]).includes(:donor_requirements, :files, :image, :address).order(:expiration_date).page params[:page]
    if params[:ajax]
      render partial: 'requirements/requirement', layout: false
    else
      render 'requirements/index'
    end
  end

  private

    def check_if_admin
      if current_admin
        redirect_to admins_welcome_index_path
      end
    end

end