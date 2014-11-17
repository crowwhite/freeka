class Admin::WelcomeController < Admin::BaseController

  def index
    unless current_admin
      flash[:notice] = "you are not authorised to view that page"
      redirect_to root_path
    end
  end

end