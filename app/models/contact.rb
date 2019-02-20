class Contact < ApplicationRecord
  has_and_belongs_to_many :offenses
  has_many :relief_messages
  has_many :contact_histories, dependent: :destroy

  validates :method, presence: true
  validates :info, presence: true, uniqueness: true

  def add_offenses(ids_string)
    old_ids = offense_ids
    new_ids = ids_string.split
    all_ids = (old_ids + new_ids).map(&:to_i).uniq
    self.offense_ids = all_ids
  end

  def contact_time
    if self.created_at == self.updated_at
      time_of_contact = self.created_at
    elsif self.updated_at > self.created_at
      time_of_contact = self.updated_at
    end

    time_of_contact.strftime 'Contacted on %m/%d/%Y'
  end

  # notify one by one
  def notify_of(ids_string)
    ids = ids_string.split
    offenses_to_notify = offenses.where id: ids
    offenses_to_notify.each do |offense|
      if !offense.pending?
        # create contact history to get things rolling
        # ContactHistory.create contact: self, offense: offense
        history = contact_histories.create offense: offense
      end
    end
  end

  # need a contact_histories_offenses table and need to remove contact_histories.offense_id
  # def notify_of(ids_string)
  #   ids = ids_string.split
  #   offenses_to_notify = offenses.where id: ids
  #   contact_histories.create offenses: offenses_to_notify
  # end
end
