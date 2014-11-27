class Admin::UsersController < Admin::BaseController
  layout 'admin'

  before_action :load_user, only: [:edit, :update, :destroy, :show, :toggle_status]

  def index
    @users = User.where.not(id: current_admin.id).order(:name)
  end

  def update
    if @user.update(update_params)
      redirect_to admins_users_path
    else
      render 'edit'
    end
  end

  def destroy
    flash[:alert] = 'Could not destroy User' unless @user.destroy
    redirect_to admins_users_path
  end

  def toggle_status
    @user.update_column(:enabled, update_params[:enabled] == 'true')
  end

  def search
    search = search_params
    @users = User.public_send("with_#{ search[:criteria] }_like", search[:text])
    if @users.length.zero?
      flash[:alert] = 'No results found'
    end
    render 'index'
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

    def search_params
      params.require(:user).require(:search).permit(:criteria, :text)
    end
end