class Admin::RequirementsController < Admin::BaseController

  before_action :load_requirement, only: [:toggle_state, :show]

  def index
    if params[:filter]
      @requirements = Requirement.public_send(params[:filter]).order(:expiration_date).page params[:page]
    else
      @requirements = Requirement.order(:expiration_date).page params[:page]
    end
  end

  def toggle_state
    if @requirement.update_column(:enabled, !@requirement.enabled)
      flash.now[:notice] = "Requirement #{ @requirement.enabled ? :Enabled : :Disabled }"
    else
      flash.now[:alert] = "Couldn't change state of Requirement"
    end
  end

  def search
    @requirements = Requirement.search(Riddle::Query.escape(params[:requirement][:search])).page params[:page]
    flash.now[:notice] = 'Nothing matched the search' if @requirements.empty?
    render :index
  end

  def filter
    @requirements = Requirement.with_category(params[:category_name]).page params[:page]
    flash.now[:notice] = 'Nothing matched the filter' if @requirements.empty?
    render :index
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(slug: params[:id])
      redirect_to admins_requirements_path({ filter: 'pending' }), alert: 'Requirement not found' unless @requirement
    end
end
