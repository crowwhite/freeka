class Admin::UsersController < Admin::BaseController

  before_action :load_user, only: [:edit, :update, :destroy, :show]
  respond_to :html

  def index
    @users = User.where.not(id: current_person.id)
  end

  def update
    @user.update(update_params)
    redirect_to users_path
  end

  def destroy
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