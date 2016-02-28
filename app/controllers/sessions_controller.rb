require 'authenticates_users'

class SessionsController < ApplicationController
  def create
    user = authenticate_user_credentials

    if user
      post_authentication user
      redirect_to donations_path
    else
      flash[:error] = 'Incorrect email or password. Please try again.'
      render :new
    end
  end

  def destroy
    logout_killing_session!
    flash[:success] = 'You have been logged out.'
    redirect_to root_path
  end

  private

  def authenticate_user_credentials
    AuthenticatesUsers.authenticate(sai_service_url, credentials[:email], credentials[:password])
  end

  def credentials
    params[:user]
  end
end
