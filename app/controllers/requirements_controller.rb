class RequirementsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :create, :update, :fulfill]
  before_action :load_requirement, only: [:edit, :update, :show, :fulfill]
  before_action :allow_only_owner, only: [:edit, :update, :fulfill]

  def index
    #FIXME_AB: in both statements we are repeating many things. we can do it in a better way like:
    # @requirements = current_user.requirements
    # @requirements.public_send(params[:filter]) if params[:filter]
    # @requirements.includes(:donor_requirements, :files).order(created_at: :desc).page params[:page]
    if params[:filter]
      @requirements = current_user.requirements.public_send(params[:filter]).includes(:donor_requirements, :files).order(created_at: :desc).page params[:page]
    else
      @requirements = current_user.requirements.includes(:donor_requirements, :files).order(created_at: :desc).page params[:page]
    end
  end

  def search
    #FIXME_AB: Simplify following statement
    @requirements = Requirement.search(Riddle::Query.escape(params[:requirement][:search]))[].page params[:page]
    flash.now[:notice] = 'Nothing matched the search' if @requirements.empty?
    render :index
  end

  def filter
    #FIXME_AB: Again repeatation ?
    @requirements = Requirement.with_category(filter_params).enabled.live.with_status_not(Requirement.statuses[:fulfilled]).page params[:page]
    @display_page = 'welcome'
    flash.now[:notice] = 'Nothing matched the filter' if @requirements.empty?
    #FIXME_AB: why not render :index ?
    render 'requirements/index'
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