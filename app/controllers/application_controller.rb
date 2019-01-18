class ApplicationController < ActionController::Base
  def after_sign_in_path_for(admin)
    panel_path
  end
end
