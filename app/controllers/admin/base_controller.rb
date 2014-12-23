class Admin::BaseController < ApplicationController
  before_action :allow_only_admin

  def allow_only_admin
    redirect_to root_path, alert: "You don't have access to that page" unless current_admin
  end
end
