#TODO -> Remove if not required.
#Fixed -- Functionality corrected
class Admin::UsersController < Admin::BaseController
  #TODO -> Move this before_filter into base_controller
  #Fixed
  before_action :load_user, only: [:edit, :update, :destroy, :show, :toggle_status]

  respond_to :html, :js

  def index
    @users = User.all_except_current(current_person.id)
  end

  def update
    #TODO -> Handle unsuccessful updation also.
    #Fixed
    if @user.update(update_params)
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def destroy
    #TODO -> Handle unsuccessful destroy also.
    #Fixed
    flash[:notice] = 'Could not destroy User' unless @user.destroy
    redirect_to admin_users_path
  end

  def toggle_status
    #TODO -> I think validation and callback execution is not required.
    #Fixed -- 'toggle' skips callbacks and 'toggle!' skips validation but update_column skips both
    @user.update_column(:enabled, update_params[:enabled] == 'true')
  end

  private
    def load_user
      @user = User.find_by(id: params[:id])
      unless @user
        redirect_to admin_users_path, alert: 'User not found'
      end
    end

    def update_params
      params.require(:user).permit(:about_me, :contact_no, :name, :email, :address, :enabled)
    end
end