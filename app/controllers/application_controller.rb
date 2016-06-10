class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
    def authenticate_user!
      if user_signed_in?
        super
      else
        redirect_to new_user_registration_path, :alert => 'Please support the project and subscribe for access to all videos.'
      end
    end

end
