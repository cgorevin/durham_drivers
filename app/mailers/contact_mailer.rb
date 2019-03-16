class ContactMailer < ApplicationMailer
  def send_message(contact_id, relief_message_id, context)
    @contact = Contact.find contact_id
    @context = context
    @relief_message = ReliefMessage.find relief_message_id
    info = @context == :create ? '[NEW]' : '[UPDATE]'
    mail to: @contact.email, subject: "#{info} Your relief details"
  end
end
