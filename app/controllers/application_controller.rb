class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  def after_sign_in_path_for(user)
    dashboard_path
  end
  def after_sign_out_path_for(user)
    root_url
  end
  protect_from_forgery with: :exception
end