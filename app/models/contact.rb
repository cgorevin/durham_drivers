class Contact < ApplicationRecord
  has_and_belongs_to_many :offenses

  has_many :contact_histories, dependent: :destroy
  has_many :relief_messages, dependent: :destroy

  validates :info, presence: true, uniqueness: true
  validates :method, presence: true

  def add_offenses(ids_string)
    old_ids = offense_ids
    new_ids = ids_string.split
    all_ids = (old_ids + new_ids).map(&:to_i).uniq
    self.offense_ids = all_ids
  end

  # need a contact_histories_offenses table
  def notify_of(ids_string)
    ids = ids_string.split
    offenses_to_notify = offenses.where id: ids

    relief_message = relief_messages.create offenses: offenses_to_notify

    offenses_to_notify.each do |offense|
      # create contact history to get things rolling
      # ContactHistory.create contact: self, offense: offense
      history = contact_histories.create(
        offense: offense, relief_message: relief_message
      )
    end
  end
end
