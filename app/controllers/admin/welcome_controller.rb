class Admin::WelcomeController < Admin::BaseController
  #TODO -> No need to check current_admin condition here.
  def index
    unless current_admin
      flash[:notice] = "you are not authorised to view that page"
      redirect_to root_path
    end
  end

end