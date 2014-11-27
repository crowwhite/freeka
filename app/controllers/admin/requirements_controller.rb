class Admin::RequirementsController < Admin::BaseController
  before_action :load_requirement, only: :toggle_state

  def index
    @requirements = Requirement.order(:expiration_date).page params[:page]
    @controller_action = 'admins/requirements#index'
  end

  def toggle_state
    @requirement.update_column(:enabled, !@requirement.enabled)
  end

  def search
    @requirements = Requirement.search(params[:requirement][:search]).page params[:page]
    render :index
  end

  def filter
    @requirements = Requirement.public_send("with_#{ filter_params[:criteria]}", filter_params[:value]).page params[:page]
    @controller_action = params[:requirement][:controller_action]
    render 'index'
  end

  private
    def load_requirement
      @requirement = Requirement.find_by(id: params[:id])
      unless @requirement
        flash[:notice] = 'requirement not found'
        redirect_to(admins_requirements_path) and return
      end
    end

    def filter_params
      params.require(:requirement).require(:filter).permit(:criteria, :value)
    end
end
