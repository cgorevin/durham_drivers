class Contact < ApplicationRecord
  has_and_belongs_to_many :offenses
  has_many :relief_messages
  has_many :contact_histories
  validates :method, presence: true
  validates :info, presence: true, uniqueness: true

  def contact_time
    if self.created_at == self.updated_at
      time_of_contact = self.created_at
    elsif self.updated_at > self.created_at
      time_of_contact = self.updated_at
    end
      time_of_contact.strftime("Contacted on %m/%d/%Y")
  end
end
