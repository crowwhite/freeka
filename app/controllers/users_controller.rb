#TODO -> Remove if not required.
class UsersController < ApplicationController
  before_action :allow_only_admin, only: [:index, :edit, :update, :destroy]
  before_action :load_user, only: [:edit, :update, :destroy, :show]

  respond_to :html

  def index
    @users = User.all_except_current
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
      @user = User.where(id: params[:id]).first
      unless @user
        redirect_to users_path, alert: 'User not found'
      end
    end

    def update_params
      params.require(:user).permit(:about_me, :contact_no, :name, :email, :address, :enabled)
    end
end