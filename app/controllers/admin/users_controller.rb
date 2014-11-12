#TODO -> Remove if not required.
class Admin::UsersController < Admin::BaseController
  #TODO -> Move this before_filter into base_controller
  before_action :allow_only_admin, only: [:index, :edit, :update, :destroy]
  before_action :load_user, only: [:edit, :update, :destroy, :show]

  respond_to :html

  def index
    @users = User.where.not(id: current_person.id)
  end

  def update
    #TODO -> Handle unsuccessful updation also.
    @user.update(update_params)
    redirect_to users_path
  end

  def destroy
    #TODO -> Handle unsuccessful destroy also.
    @user.destroy
    redirect_to users_path
  end

  private
    def load_user
      @user = User.find_by(id: params[:id])
      unless @user
        redirect_to users_path, alert: 'User not found'
      end
    end

    def update_params
      params.require(:user).permit(:about_me, :contact_no, :name, :email, :address, :enabled)
    end
end