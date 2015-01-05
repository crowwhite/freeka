class User::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected
    def after_update_path_for(user)
      user
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.for(:sign_up) << [:name, :contact_no, :about_me, :address]
    end

    def configure_account_update_params
      devise_parameter_sanitizer.for(:account_update) << [:name, :about_me, :address, :contact_no, image_attributes: [:id, :attachment]]
    end
end
