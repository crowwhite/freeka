class DonationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_donation, only: [:donated]

  def index
    @donations = current_user.donations.page params[:page]
  end

  def donated
    @donation.donate
  end

  private
    def load_donation
      @donation = Requirement.find_by(id: params[:id])
      unless @donation
        flash[:notice] = 'donation not found'
        redirect_to(requirements_path) and return
      end
    end
end