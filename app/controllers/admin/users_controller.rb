class Admin::UsersController < Admin::BaseController
  layout 'admin'

  before_action :load_user, only: [:edit, :update, :destroy, :show, :toggle_status]

  respond_to :html, :js

  def index
    @users = User.all_except_current(current_admin.try(:id))
  end

  def update
    if @user.update(update_params)
      redirect_to admins_users_path
    else
      render 'edit'
    end
  end

  def destroy
    flash[:notice] = 'Could not destroy User' unless @user.destroy
    redirect_to admins_users_path
  end

  def toggle_status
    @user.update_column(:enabled, update_params[:enabled] == 'true')
  end

  private
    def load_user
      @user = User.find_by(id: params[:id])
      unless @user
        redirect_to admins_users_path, alert: 'User not found'
      end
    end

    def update_params
      params.require(:user).permit(:about_me, :contact_no, :name, :email, :address, :enabled)
    end
end