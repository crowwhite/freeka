class DonationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @donations = current_user.donations.includes(:donor_requirements, :files).order('donor_requirements.created_at DESC').page params[:page]
    render 'requirements/index'
  end

end