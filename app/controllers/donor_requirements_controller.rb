class DonorRequirementsController < ApplicationController
  include Donation

  before_action :set_requirement
  before_action :authenticate_user!

  def create
    @donor_requirement = DonorRequirement.new(requirement_id: params[:requirement_id], donor_id: current_user.id)
    if @donor_requirement.save
      flash.now[:notice] = 'Interested'
    else
      flash.now[:alert] = "Couldn't show interest"
    end
    load_donations
    render 'requirements/toggle_interest'
  end

  def destroy
    @donor_requirement = DonorRequirement.find_by(requirement_id: params[:requirement_id], donor_id: current_user.id)
    if @donor_requirement.destroy
      flash.now[:notice] = 'successfully toggled interest'
    else
      flash.now[:alert] = 'could not remove interest'
    end
    render 'requirements/toggle_interest'
  end

  private
    def set_requirement
      @requirement = Requirement.find_by(id: params[:requirement_id])
    end
end
