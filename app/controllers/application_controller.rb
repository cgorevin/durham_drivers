class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_locale

  private

  def set_locale
    locale = params[:locale]
    I18n.locale = locale || 'en'
    Rails.application.routes.default_url_options = { locale: locale }
  end

  def after_sign_in_path_for(admin)
    panel_path
  end
end
