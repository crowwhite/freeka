class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def allow_only_admin
    redirect_to new_person_session_path unless current_person && current_person.admin?
  end

end
