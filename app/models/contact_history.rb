class ContactHistory < ApplicationRecord
  after_create :deliver_message

  belongs_to :contact
  belongs_to :offense
  belongs_to :relief_message, optional: true

  private

  def deliver_message
    if contact.method == 'email'
      # send email
      ContactMailer.send_message(contact_id, offense_id).deliver_now
    elsif contact.method == 'text'
      # send text
      p 'I SHOULD SEND A TEXT MESSAGE'
    end
  end
end
