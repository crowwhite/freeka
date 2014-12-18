class WelcomeController < ApplicationController
  include Donation

  before_action :check_if_admin, only: :index

  def index
    @requirements = Requirement.enabled.live.with_status_not(Requirement.statuses[:fulfilled]).includes(:donor_requirements, :files).order(:expiration_date).page params[:page]
    load_donations
    render 'requirements/index'
  end

  def filter
    @requirements = Requirement.with_category(filter_params).page params[:page]
    flash.now[:notice] = 'Nothing matched the filter' if @requirements.empty?
    render 'requirements/index'
  end

  private
    def filter_params
      params.require(:category_filter)
    end

    def check_if_admin
      if current_admin
        redirect_to admins_welcome_index_path
      end
    end

end