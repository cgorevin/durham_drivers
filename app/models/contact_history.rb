class ContactHistory < ApplicationRecord
  after_create :deliver_message

  belongs_to :contact
  belongs_to :offense
  belongs_to :relief_message

  def contact_time
    time_of_contact = self.created_at

    if contact.method == 'email'
      time_of_contact.strftime 'Emailed on %m/%d/%Y %l:%M:%S %P'
    else
      time_of_contact.strftime 'Texted on %m/%d/%Y %l:%M:%S %P'
    end
  end

  private


  def deliver_message
    if contact.method == 'email'
      # send email
      ContactMailer.send_message(contact_id, offense_id, relief_message_id)
                   .deliver_now
    elsif contact.method == 'text'
      # send text
      p 'I SHOULD SEND A TEXT MESSAGE'
    end
  end
end
