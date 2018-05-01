class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(mail: params[:mail])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      session[:user_id] = user.id
      flash[:success] = "Account activated!"
      redirect_to tasks_months_path year: Date.today.year, month: Date.today.month
    else
      flash[:danger] = "Invalid activation link"
      redirect_to login_url
    end
  end
end
