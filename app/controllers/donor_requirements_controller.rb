class DonorRequirementsController < ApplicationController

  before_action :set_requirement, only: [:create, :destroy]
  before_action :restrict_owner, only: :create
  before_action :authenticate_user!

  def create
    @donor_requirement = @requirement.donor_requirements.build(donor_id: current_user.id)
    if @donor_requirement.save
      flash[:notice] = 'Thank you for showing interest in the request'
    else
      flash[:alert] = "Couldn't show interest"
    end
    redirect_to @requirement
  end

  def destroy
    @donor_requirement = @requirement.donor_requirements.find_by(donor_id: current_user.id)
    if @donor_requirement.destroy
      flash[:notice] = 'successfully withdrawn interest'
    else
      flash[:alert] = 'could not remove interest'
    end
    redirect_to @requirement
  end

  private
    def set_requirement
      @requirement = Requirement.find_by(id: params[:requirement_id])
      unless @requirement
        flash[:alert] = 'Requirement not found'
        redirect_to(requirements_path)
      end
    end

    def restrict_owner
      redirect_to(@requirement, alert: 'Cannot show interest on your own request') if @requirement.requestor_id == current_user.id
    end
end
