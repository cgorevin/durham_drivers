class ApplicationController < ActionController::Base
  protect_from_forgery

  around_action :set_time_zone

  before_action :set_locale

  private

  def after_sign_in_path_for(admin)
    panel_path
  end

  def set_locale
    locale = params[:locale]
    I18n.locale = locale || 'en'
    Rails.application.routes.default_url_options = { locale: locale }
  end

  def set_time_zone(&block)
    time_zone = 'Eastern Time (US & Canada)'
    Time.use_zone(time_zone, &block)
  end
end
