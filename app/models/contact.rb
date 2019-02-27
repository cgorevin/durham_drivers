class Contact < ApplicationRecord
  has_and_belongs_to_many :offenses

  has_many :contact_histories, dependent: :destroy
  has_many :relief_messages, dependent: :destroy

  validates :info, presence: true, uniqueness: true
  validates :method, presence: true

  def add_offenses(ids_array)
    old_ids = offense_ids
    new_ids = ids_array
    all_ids = (old_ids + new_ids).map(&:to_i).uniq
    self.offense_ids = all_ids

    notify_of ids_array
  end

  # need a contact_histories_offenses table
  def notify_of(ids_array)
    offenses_to_notify = offenses.where id: ids_array

    relief_message = relief_messages.create offenses: offenses_to_notify

    contact_histories.create relief_message: relief_message
  end
end
