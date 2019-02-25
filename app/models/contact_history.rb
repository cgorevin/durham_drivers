class ContactHistory < ApplicationRecord
  belongs_to :contact
  belongs_to :relief_message

  def contact_time
    time_of_contact = self.created_at

    if contact.method == 'email'
      time_of_contact.strftime 'Emailed on %m/%d/%Y %l:%M:%S %P'
    else
      time_of_contact.strftime 'Texted on %m/%d/%Y %l:%M:%S %P'
    end
  end
end
