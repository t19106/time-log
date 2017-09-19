class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    User.find_by(id: session[:user_id]) || User::Logout.new
  end
end
