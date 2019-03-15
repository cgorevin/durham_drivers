class ReliefMessageJob < ApplicationJob
  queue_as :default

  def perform(contact_id)
    contact = Contact.find contact_id
    contact.notify_of contact.offense_ids
  end
end
