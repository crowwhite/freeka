class RequirementsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :update, :destroy, :fulfill, :reject_donor]
  before_action :load_requirement, only: [:edit, :update, :show, :destroy, :toggle_interest, :fulfill, :reject_donor]
  before_action :allow_only_owner, only: [:edit, :update, :reject_donor, :destroy, :fulfill]

  def index
    if params[:filter]
      @requirements = current_user.requirements.public_send(params[:filter]).includes(:donor_requirements, :files).order(created_at: :desc).page params[:page]
    else
      @requirements = current_user.requirements.includes(:donor_requirements, :files).order(created_at: :desc).page params[:page]
    end
  end

  def search
    @requirements = Requirement.search(params[:requirement][:search]).page params[:page]
    flash.now[:notice] = 'Nothing matched the search' if @requirements.empty?
    render :index
  end

  def new
    @requirement = current_user.requirements.build
    @requirement.build_address
  end

  def create
    @requirement = current_user.requirements.build(requirement_params)
    if @requirement.save
      redirect_to @requirement, notice: 'Requirement created'
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
    redirect_to requirements_path(filter: 'pending')
  end

  def fulfill
    if @requirement.fulfill!
      redirect_to @requirement, notice: 'Successfully fulfilled the requirement.'
    else
      redirect_to @requirement, alert: 'Could not fulfill the requirement.'
    end
  end

  def reject_donor
    if @requirement.reject_current_donor
      flash[:notice] = 'Donor Rejected'
      @requirement.update_donors
    else
      flash[:alert] = "Donor couldn't be rejected"
    end
    redirect_to requirements_path(filter: 'pending')
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      unless @requirement
        flash[:alert] = 'Requirement not found'
        redirect_to(requirements_path(filter: 'pending'))
      end
    end

    def requirement_params
      params[:requirement][:files_attributes] = params[:requirement][:files_attributes].values.flatten if params[:requirement] && params[:requirement][:files_attributes].try(:is_a?, Hash)
      params.require(:requirement).permit(:title, :details, { category_ids: [] }, :expiration_date, :enabled, image_attributes: [:id, :attachment, :attacheable_sub_type], files_attributes: [:id, :attachment, :_destroy], address_attributes: [:id, :street, :city, :country_code, :state_code])
    end

    def allow_only_owner
      if current_user.id != @requirement.requestor_id
        flash[:alert] = 'Not authorised to use this page'
        redirect_to @requirement
      end
    end
end