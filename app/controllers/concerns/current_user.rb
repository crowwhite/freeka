module CurrentUser
  extend ActiveSupport::Concern
  
  private

  def user_signed_in?
    !!warden.user
  end
  
end