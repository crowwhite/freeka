class WelcomeController < ApplicationController
  include Donation

  before_action :check_if_admin, only: :index

  def index
    debugger
    # TODO: What is `2`? Do not use hardcoded values anywhere. Find some good way.
    @requirements = Requirement.enabled.with_status_not(Requirement.statuses[:fulfilled]).includes(:address, :donor_requirements, :categories, :interested_donors).order(:expiration_date).page params[:page]
    load_donations
    render 'requirements/index'
  end

  private
    def check_if_admin
      if current_admin
        redirect_to admins_welcome_index_path
      end
    end

end