class SessionsController < ApplicationController
  def new
  end

  def create
      # notice that @user is an instance variable, which means it can be tested
      # using 'assigns(:user)' and that @user is available in views
      @user = User.find_by(email: params[:session][:email].downcase)
      if @user && @user.authenticate(params[:session][:password])
          if @user.activated?
              log_in @user
              # remember user only if they check the box when logging in
              params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
              redirect_back_or root_url
          else
              message = "Account not activated. Check your email for the activation link."
              flash[:warning] = message
              redirect_to root_url
          end
      else
          flash.now[:danger] = 'Invalid email/password'
          render 'new'
      end
  end

  def destroy
      log_out if logged_in?
      redirect_to root_url # redirect, so use root_url instead of root_path
  end
end
