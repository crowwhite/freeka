class Admin::BaseController < ApplicationController

  def allow_only_admin
    unless current_person && current_person.admin?
      flash[:notice] = "You don't have access to that page"
      redirect_to root_path
    end
  end
end
