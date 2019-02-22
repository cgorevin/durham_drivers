class ContactHistory < ApplicationRecord
  after_create :deliver_message

  belongs_to :contact
  belongs_to :offense
  belongs_to :relief_message

  def contact_time
    if self.created_at == self.updated_at
      time_of_contact = self.created_at
    elsif self.updated_at > self.created_at
      time_of_contact = self.updated_at
    end

    time_of_contact.strftime 'Contacted on %m/%d/%Y %l:%M:%S %P'
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
