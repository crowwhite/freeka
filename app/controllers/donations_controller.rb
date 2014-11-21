class DonationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @donations = current_user.donations.page params[:page]
  end

  def donated
  end
end