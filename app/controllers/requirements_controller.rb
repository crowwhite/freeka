class RequirementsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :update, :destroy, :fulfill, :reject_donor]
  before_action :load_requirement, only: [:edit, :update, :show, :destroy, :toggle_interest, :fulfill, :reject_donor]
  before_action :check_if_owner, only: [:edit, :update, :reject_donor, :destroy]

  def index
    @requirements = current_user.requirements.order(created_at: :desc).page params[:page]
  end

  def search
    if params[:requirement][:controller_action] == 'requirements#index'
      @requirements = Requirement.search(params[:requirement][:search]).page params[:page]
    else
      @requirements = Requirement.search(params[:requirement][:search], with: { expiration_date: Time.now..Time.now + 10.year, enabled: true }, without: { status: 2 }).page params[:page]
    end
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
    redirect_to requirements_path
  end

  def fulfill
    flash.now[:alert] = 'This request has no donors, you can probably delete it.' unless @requirement.fulfill!
  end

  def reject_donor
    if @requirement.reject_current_donor
      flash[:notice] = 'Donor Rejected'
      @requirement.update_donors
    else
      flash[:alert] = "Donor couldn't be rejected"
    end
    redirect_to requirements_path
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

    def check_if_owner
      if current_user.id != @requirement.requestor_id
        flash[:alert] = 'Not authorised to use this page'
        redirect_to @requirement
      end
    end
end