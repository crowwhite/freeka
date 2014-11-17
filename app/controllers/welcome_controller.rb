class WelcomeController < ApplicationController

  def index
    if current_admin
      redirect_to admins_welcome_index_path
    end
  end

  #TODO -> Make different welcome controller for admin and make index action in it.
  #Fixed
end