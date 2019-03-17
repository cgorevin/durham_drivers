class ContactMailer < ApplicationMailer
  def send_message(contact_id, relief_message_id)
    @contact = Contact.find contact_id
    @relief_message = ReliefMessage.find relief_message_id
    info = @relief_message.new? ? '[NEW]' : '[UPDATE]'
    mail to: @contact.email, subject: "#{info} Your relief details"
  end
end
