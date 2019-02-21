class ContactMailer < ApplicationMailer
  def send_message(contact_id, offense_id, relief_message_id)
    @contact = Contact.find(contact_id)
    @offense = Offense.find(offense_id)
    @relief_message = ReliefMessage.find(relief_message_id)
    mail to: "to@example.org"
  end
end
