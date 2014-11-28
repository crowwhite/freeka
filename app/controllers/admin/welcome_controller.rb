class Admin::WelcomeController < Admin::BaseController
  def index
    @controller_action = 'welcome#index'
  end
end