class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
        remember_login user
      else
        message_activation
      end
    else
      fail_create
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def fail_create
    flash.now[:danger] = t "notice"
    render :new
  end

  def message_activation
    flash[:warning] = t "not_activeted"
    redirect_to root_url
  end

  def remember_login user
    log_in user
    remerber_login = params[:session][:remember_me]
    remerber_login == Settings.remember_me ? remember(user) : forget(user)
    redirect_to user
  end
end
