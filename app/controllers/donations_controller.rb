class DonationsController < ApplicationController
  include Donation

  before_action :authenticate_user!
  before_action :load_donations, only: [:donate]

  def index
    @donations = current_user.donations.page params[:page]
  end

  # TODO: Rename
  # Fixed
  def donate
    @donation.donate
  end

  private
    def load_donation
      @donation = Requirement.find_by(id: params[:id])
      unless @donation
        flash[:alert] = 'Donation not found'
        redirect_to(requirements_path)
      end
    end
end