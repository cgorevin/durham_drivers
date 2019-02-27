class ContactMailer < ApplicationMailer
  def send_message(contact_id, relief_message_id)
    @contact = Contact.find contact_id
    @relief_message = ReliefMessage.find relief_message_id
    mail to: @contact.info, subject: 'Your relief details'
  end
end
