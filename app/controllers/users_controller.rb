class UsersController < ApplicationController
  before_action :load_user, only: [:show, :buy_coins]

  private
    def load_user
      @user = User.find_by(slug: params[:id])
      redirect_to root_path, alert: 'User not found' unless @user
    end
end