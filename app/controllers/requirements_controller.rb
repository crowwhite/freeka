class RequirementsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_requirement, only: [:edit, :show, :toggle_state, :destroy]

  def index
    @requirements = current_user.requirements
  end

  def new
    @requirement = current_user.requirements.build
  end

  def create
    @requirement = current_user.requirements.build(requirement_params)
    if @requirement.save
      redirect_to requirements_path
    else
      render 'new'
    end
  end

  def destroy
    flash[:notice] = "requirement could not be deleted" unless @requirement.destroy
    redirect_to requirements_path
  end

  def toggle_state
    @requirement.update(requirement_params)
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      unless @requirement
        flash[:notice] = 'requirement not found'
        redirect_to requirements_path
      end
    end

    def requirement_params
      params.require(:requirement).permit(:title, :details, { category_ids: [] }, :expiration_date, :enabled, address_attributes: [:id, :street, :city, :country_code, :state_code])
    end
end