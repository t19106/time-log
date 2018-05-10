class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      UserMailer.account_activation(user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to login_url
      # session[:user_id] = user.id
      # redirect_to tasks_months_path year: Date.today.year, month: Date.today.month
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:mail, :password, :password_confirmation)
    end
end
