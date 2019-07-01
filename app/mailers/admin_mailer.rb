class AdminMailer < ApplicationMailer
  def send_invite(id)
    @admin = Admin.find id

    mail to: @admin.email, subject: "Admin Invite"
  end
end
