class User::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:name, :contact_no, :about_me, :address]
  end
end
