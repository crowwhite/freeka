class DonorRequirementsController < ApplicationController

  before_action :set_requirement, only: [:create, :destroy, :mark_donated]
  before_action :set_donor_requirement, only: [:destroy, :mark_donated]
  before_action :check_requirement_status, only: [:destroy, :mark_donated]
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
    if @donor_requirement.destroy
      flash[:notice] = 'Successfully withdrawn interest'
    else
      flash[:alert] = 'Could not remove interest'
    end
    redirect_to @requirement
  end

  def mark_donated
    if @donor_requirement.donate!
      redirect_to @requirement, notice: 'You have successfully donated the item'
    else
      redirect_to @requirement, alert: 'Failed to mark it donated'
    end
  end

  private
    def set_requirement
      @requirement = Requirement.find_by(id: params[:requirement_id])
      unless @requirement
        flash[:alert] = 'Requirement not found'
        redirect_to(requirements_path(filter: 'pending'))
      end
    end

    def set_donor_requirement
      @donor_requirement = @requirement.donor_requirements.find_by(donor_id: current_user.id)
      unless @donor_requirement
        flash[:alert] = 'Interest not shown for this requirement'
        redirect_to(requirements_path(filter: 'pending'))
      end
    end

    def check_requirement_status
      redirect_to @requirement, notice: 'This requirement is already fulfilled.' if @requirement.fulfilled?
    end

    def restrict_owner
      redirect_to(@requirement, alert: 'Cannot show interest on your own request') if @requirement.requestor_id == current_user.id
    end
end
