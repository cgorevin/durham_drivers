class AdminsController < ApplicationController
  before_action :authenticate_admin!, except: [:edit, :update]
  before_action :set_admin, only: [:edit, :update]
  before_action :set_token, only: [:edit, :update]

  def index
    @admins = Admin.all.page(nil)
  end

  def new
    @admin = Admin.new
  end

  def create
    admin = Admin.new admin_params

    if admin.save
      redirect_to admins_path, notice: "#{admin.email} has been invited to Second Chance Driving."
    else
      redirect_to new_admin_path, alert: admin.errors.to_a.join('. ')
    end
  end

  def edit
  end

  def update
    if @admin.update admin_params
      sign_in @admin
      redirect_to panel_path, notice: 'Password set successfully. You are now logged in.'
    else
      redirect_to edit_admin_path(@admin, token: @token), alert: @admin.errors.to_a.join('. ')
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end

  def set_admin
    @admin = Admin.find params[:id]
  end

  def set_token
    @token = params[:token]

    if @admin.token != @token
      redirect_to admins_path, alert: 'Not allowed there.'
    end
  end
end
