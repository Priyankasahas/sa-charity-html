require 'service'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sai_service_url
    secrets = Rails.application.secrets
    Service.new(secrets.sai_service, secrets.sai_username, secrets.sai_password)
  end

  helper_method :sai_service_url
end
