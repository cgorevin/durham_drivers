class ContactHistory < ApplicationRecord
  belongs_to :contact
  belongs_to :relief_message, optional: false

  delegate :new, to: :relief_message

  def contact_time
    time_of_contact = self.created_at
    time_of_contact.strftime "%-m/%d/%Y %l:%M %P"
  end

  def context
    relief_message.new? ? 'New' : 'Update'
  end
end
