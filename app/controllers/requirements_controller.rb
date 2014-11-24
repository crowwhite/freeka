class RequirementsController < ApplicationController
  before_action :authenticate_user!, except: [:welcome, :show]
  before_action :load_requirement, only: [:edit, :update, :show, :toggle_state, :destroy, :toggle_interest, :donated, :fulfilled, :reject_donor]
  before_action :check_status_for_pending, only: :toggle_state

  def index
    @requirements = current_user.requirements.order(:expiration_date).page params[:page]
  end

  def new
    @requirement = current_user.requirements.build
  end

  def edit
    unless current_user.id == @requirement.requestor_id
      flash[:alert] = 'not authorised to use this page'
      redirect_to @requirement
    end
  end

  def create
    @requirement = current_user.requirements.build(requirement_params)
    if @requirement.save
      redirect_to requirements_path
    else
      render 'new'
    end
  end

  def update
    if current_user.id != @requirement.requestor_id
      flash[:alert] = 'not authorised to use this page'
      redirect_to @requirement
    elsif @requirement.update(requirement_params)
      redirect_to @requirement
    else
      render 'edit'
    end
  end

  def destroy
    flash[:notice] = "requirement could not be deleted" unless @requirement.destroy
    redirect_to requirements_path
  end

  def toggle_state
    @requirement.update(enabled: requirement_params[:enabled])
  end

  def toggle_interest
    flash[:notice] = "successful donation can't be undone" unless @requirement.toggle_interest(current_user.id)

  end

  def fulfilled
    flash[:notice] = 'this request has no donors, you can disable or delete it.' unless @requirement.fulfill!
  end

  def reject_donor
    @requirement.reject_current_donor
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      unless @requirement
        flash[:notice] = 'requirement not found'
        redirect_to(requirements_path) and return
      end
    end

    def requirement_params
      params.require(:requirement).permit(:title, :details, { category_ids: [] }, :expiration_date, :enabled, address_attributes: [:id, :street, :city, :country_code, :state_code])
    end

    def check_status_for_pending
      unless @requirement.pending?
        flash[:notice] = 'this request has received some response, hence cant be disabled'
        render 'toggle_state' and return
      end
    end
end