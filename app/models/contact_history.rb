class ContactHistory < ApplicationRecord
  belongs_to :contact
  belongs_to :relief_message

  def contact_time
    time_of_contact = self.created_at
    method = contact.method == 'email' ? 'Emailed' : 'Texted'
    time_of_contact.strftime "#{method} on %-m/%d/%Y %l:%M %P"
  end
end
