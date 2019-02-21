class ContactMailer < ApplicationMailer
  def send_message(contact_id, offense_id, relief_message_id)
    @contact = Contact.find(contact_id)
    @offense = Offense.find(offense_id)
    @relief_message = ReliefMessage.find(relief_message_id)
    if @offense.approved?
      approved
    else
      denied
    end
  end


  def approved
    @greeting = "Hi"

    mail to: "to@example.org", template_name: 'approved'
  end

  def denied
    @greeting = "Hi"

    mail to: "to@example.org", template_name: 'denied'
  end
end
