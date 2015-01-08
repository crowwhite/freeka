class RequirementsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :update, :fulfill]
  before_action :load_requirement, only: [:edit, :update, :show, :fulfill]
  before_action :allow_only_owner, only: [:edit, :update, :fulfill]

  def index
    @requirements = current_user.requirements
    @requirements = @requirements.public_send(params[:filter]) if params[:filter]
    @requirements = @requirements.includes(:donor_requirements, :files, :image, :address)
    if params[:filter] == 'pending'
      @requirements = @requirements.order(created_at: :desc)
    elsif params[:filter] == 'fulfilled'
      @requirements = @requirements.order(updated_at: :desc)
    end
    @requirements = @requirements.page params[:page]
  end

  def search
    searched_text = Riddle::Query.escape(params[:requirement][:search])
    @requirements = Requirement.search(searched_text).page params[:page]
    flash.now[:notice] = 'Nothing matched the search' if @requirements.empty?
    render :index
  end

  def filter
    @requirements = Requirement.with_category(params[:category_name]).enabled.live.with_status_not(Requirement.statuses[:fulfilled]).page params[:page]
    @display_page = 'welcome'
    flash.now[:notice] = @requirements.empty? ? 'Nothing matched the filter' : 'Currently filtered by ' + params[:category_name].humanize
    render :index
  end

  def new
    @requirement = current_user.requirements.build
    @requirement.build_address
  end

  def show
    @donor_requirement = @requirement.donor_requirements.find_by(donor_id: current_user.try(:id))
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

  def fulfill
    if @requirement.fulfill!
      redirect_to @requirement, notice: 'Successfully fulfilled the requirement.'
    else
      redirect_to @requirement, alert: 'Could not fulfill the requirement.'
    end
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      redirect_to requirements_path(filter: 'pending'), alert: 'Requirement not found' unless @requirement
    end

    def requirement_params
      params[:requirement][:files_attributes] = params[:requirement][:files_attributes].values.flatten if params[:requirement] && params[:requirement][:files_attributes].try(:is_a?, Hash)
      params.require(:requirement).permit(:title, :details, { category_ids: [] }, :expiration_date, :enabled, image_attributes: [:id, :attachment, :attacheable_sub_type], files_attributes: [:id, :attachment, :_destroy], address_attributes: [:id, :street, :city, :country_code, :state_code])
    end

    def allow_only_owner
      redirect_to @requirement, alert: 'Not authorised to use this page' if current_user.id != @requirement.requestor_id
    end

    def filter_params
      params.require(:category_filter)
    end
end