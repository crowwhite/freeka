class RequirementsController < ApplicationController
  before_action :authenticate_user!, except: [:welcome, :show, :search, :filter]
  before_action :load_requirement, only: [:edit, :update, :show, :toggle_state, :destroy, :toggle_interest, :donated, :fulfilled, :reject_donor]
  before_action :check_status_for_pending, only: :toggle_state

  def index
    @requirements = current_user.requirements.order(:expiration_date).page params[:page]
    @controller_action = 'requirements#index'
  end

  def search
    @requirements = Requirement.search(params[:requirement][:search]).page params[:page]
    @controller_action = params[:requirement][:controller_action]
    render :index
  end

  def filter
    @controller_action = params[:requirement][:controller_action]
    if @controller_action.split('#')[0] == 'welcome'
      @requirements = Requirement.public_send("with_#{ filter_params[:criteria]}", filter_params[:value]).page params[:page]
    elsif current_user
      @requirements = Requirement.public_send("with_#{ filter_params[:criteria]}", filter_params[:value]).where(requestor_id: current_user.id).page params[:page]
    end
    if current_admin
      render 'admin/requirements/index'
    else
      render :index
    end
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
    flash[:alert] = "requirement could not be deleted" unless @requirement.destroy
    redirect_to requirements_path
  end

  def toggle_state
    @requirement.update(enabled: requirement_params[:enabled])
  end

  def toggle_interest
    flash[:alert] = "successful donation can't be undone" unless @requirement.toggle_interest(current_user.id)
    load_donations
  end

  def fulfilled
    flash[:alert] = 'this request has no donors, you can disable or delete it.' unless @requirement.fulfill!
  end

  def reject_donor
    @requirement.reject_current_donor
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      unless @requirement
        flash[:alert] = 'requirement not found'
        redirect_to(requirements_path) and return
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
        flash[:alert] = 'this request has received some response, hence cant be disabled'
        render 'toggle_state' and return
      end
    end
end