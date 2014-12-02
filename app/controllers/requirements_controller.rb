class RequirementsController < ApplicationController
  #TODO: Use `only`
  # Fixed
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :update, :destroy, :toggle_state, :fulfilled, :reject_donor]
  before_action :check_if_owner, only: [:edit, :update, :toggle_state, :reject_donor]
  prepend_before_action :load_requirement, only: [:edit, :update, :show, :toggle_state, :destroy, :toggle_interest, :donated, :fulfilled, :reject_donor]
  before_action :check_status_for_pending, only: :toggle_state

  def index
    @requirements = current_user.requirements.order(created_at: :desc).page params[:page]
    #TODO: Please refactor. No need of @controller_action anywhere.
    # Fixed
  end

  def search
    @requirements = Requirement.search(params[:requirement][:search]).page params[:page]
    flash.now[:notice] = 'Nothing matched the search' if @requirements.empty?
    @controller_action = params[:requirement][:controller_action]
    render :index
  end

  def filter
    @controller_action = params[:requirement][:controller_action]
    if @controller_action.split('#')[0] == 'welcome'
      @requirements = Requirement.public_send("with_#{ filter_params[:criteria] }", filter_params[:value]).page params[:page]
    elsif current_user
      @requirements = Requirement.public_send("with_#{ filter_params[:criteria] }", filter_params[:value]).where(requestor_id: current_user.id).page params[:page]
    end
    flash.now[:notice] = 'Nothing matched the filter' if @requirements.empty?
    if current_admin
      render 'admin/requirements/index'
    else
      render :index
    end
  end

  def new
    @requirement = current_user.requirements.build
    @requirement.build_address
  end

  def create
    @requirement = current_user.requirements.build(requirement_params)
    if @requirement.save
      redirect_to requirements_path, notice: 'Requirement created'
    else
      flash.now[:alert] = 'Some errors prevented the creation of requirement'
      render :new
    end
  end

  def update
    #TODO: Move authorization code out of action.
    # Fixed
    if @requirement.update(requirement_params)
      redirect_to @requirement, notice: 'Requirement updated'
    else
      flash.now[:alert] = 'Updation of requirement failed'
      render :edit
    end
  end

  def destroy
    if @requirement.destroy
      flash[:notice] = "Requirement destroyed!"
    else
      flash[:alert] = "Requirement could not be deleted"
    end
    #TODO: Show notice if requirement destroyed
    # Fixed
    redirect_to requirements_path
  end

  def toggle_state
    if @requirement.update(enabled: requirement_params[:enabled])
      flash.now[:notice] = "Updated state to #{ @requirement.enabled ? :Enabled : :Disabled }"
    else
      flash.now[:alert] = 'Updation of state failed'
    end
  end

  def fulfilled
    flash.now[:alert] = 'This request has no donors, you can probably delete it.' unless @requirement.fulfill!
  end

  def reject_donor
    if @requirement.reject_current_donor
      flash.now[:notice] = 'Donor Rejected'
    else
      flash.now[:alert] = "Donor couldn't be rejected"
    end
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      unless @requirement
        flash[:alert] = 'Requirement not found'
        redirect_to(requirements_path)
      end
    end

    def requirement_params
      params.require(:requirement).permit(:title, :details, { category_ids: [] }, :expiration_date, :enabled, address_attributes: [:id, :street, :city, :country_code, :state_code])
    end

    def filter_params
      params.require(:requirement).require(:filter).permit(:criteria, :value)
    end

    def check_status_for_pending
      unless @requirement.pending?
        flash.now[:alert] = 'This request has received some response, hence cant be disabled'
        render 'toggle_state'
      end
    end

    def check_if_owner
      if current_user.id != @requirement.requestor_id
        flash[:alert] = 'Not authorised to use this page'
        redirect_to @requirement
      end
    end
end