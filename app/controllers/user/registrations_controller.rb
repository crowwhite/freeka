class User::RegistrationsController < Devise::RegistrationsController
  # TODO: Use before_action.
  # Fixed --what is the difference? Stack overflow says it is just a name change
  before_action :configure_sign_up_params, only: [:create]
  
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:name, :contact_no, :about_me, :address]
  end
end
