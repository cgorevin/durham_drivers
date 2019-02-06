class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
    Rails.application.routes.default_url_options[:locale]= I18n.locale
  end

  def after_sign_in_path_for(admin)
    panel_path
  end
end
