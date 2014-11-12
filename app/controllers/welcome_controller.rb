class WelcomeController < ApplicationController

  def index
    if current_person.try(:admin?)
      redirect_to admin_welcome_path
    end
  end
end