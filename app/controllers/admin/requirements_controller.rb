class Admin::RequirementsController < Admin::BaseController
  before_action :load_requirement, only: :toggle_state

  def index
    @requirements = Requirement.order(:expiration_date).page params[:page]
  end

  def toggle_state
    if @requirement.update_column(:enabled, !@requirement.enabled)
      flash.now[:notice] = "Requirement #{ @requirement.enabled ? :Enabled : :Disabled }"
    else
      flash.now[:alert] = "Couldn't change state of Requirement"
    end
  end

  def search
    @requirements = Requirement.search(params[:requirement][:search].gsub('@', '\\@')).page params[:page]
    flash.now[:notice] = 'Nothing matched the search' if @requirements.empty?
    render :index
  end

  def filter
    @requirements = Requirement.public_send("with_#{ filter_params[:criteria]}", filter_params[:value]).page params[:page]
    flash.now[:notice] = 'Nothing matched the filter' if @requirements.empty?
    @controller_action = params[:requirement][:controller_action]
    render :index
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      unless @requirement
        flash[:alert] = 'requirement not found'
        redirect_to(admins_requirements_path)
      end
    end

    def filter_params
      params.require(:requirement).require(:filter).permit(:criteria, :value)
    end
end
