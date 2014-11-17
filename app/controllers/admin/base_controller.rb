class Admin::BaseController < ApplicationController
  before_action :allow_only_admin

  def allow_only_admin
    unless current_admin
      flash[:notice] = "You don't have access to that page"
      redirect_to root_path
    end
  end
end
