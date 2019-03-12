class Contact < ApplicationRecord
  STATES = %w(AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY).freeze

  has_and_belongs_to_many :offenses

  has_many :contact_histories, dependent: :destroy
  has_many :relief_messages, dependent: :destroy

  # validates :info, presence: true, uniqueness: { scope: :requestor_name }
  # validates :relief_method, presence: true
  validates :relief_method, presence: true, inclusion: {
    in: %w[email phone],
    message: %("%{value}" is not a valid contact method)
  }

  validates :requestor_name, presence: true, allow_blank: true

  validate :email_or_phone

  def add_offenses(ids_array)
    old_ids = offense_ids
    new_ids = ids_array
    all_ids = (old_ids + new_ids).map(&:to_i).uniq
    self.offense_ids = all_ids

    notify_of ids_array
  end

  def info
    out = ''
    out << "phone: #{phone}" if phone.present?
    out << "email: #{email}" if email.present?
    out
  end

  # need a contact_histories_offenses table
  def notify_of(ids_array)
    offenses_to_notify = offenses.where id: ids_array

    relief_message = relief_messages.create offenses: offenses_to_notify

    contact_histories.create relief_message: relief_message
  end


  private

  def email_or_phone
    unless email.blank? || phone.blank?
      errors.add :email, 'or phone must be present'
    end
  end
end
