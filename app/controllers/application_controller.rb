class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # TODO: Move to respective controllers or a concern.
  # Fixed
end
