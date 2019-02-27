# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/approved
  def approved
    ContactMailer.approved
  end

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/denied
  def denied
    ContactMailer.denied
  end

end
