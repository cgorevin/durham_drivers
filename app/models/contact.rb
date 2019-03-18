
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

  def add_offenses(new_ids)
    old_ids = offense_ids
    all_ids = (old_ids + new_ids.to_a).map(&:to_i).uniq
    self.offense_ids = all_ids

    notify_of all_ids
  end

  def info
    out = ''
    out << "Phone: #{phone}" if phone.present?
    out << "Email: #{email}" if email.present?
    out
  end

  # need a contact_histories_offenses table
  def notify_of(ids_array, context = :create)
    offenses_to_notify = offenses.where id: ids_array

    relief_message = relief_messages.create offenses: offenses_to_notify, new: context == :create

    contact_histories.create relief_message: relief_message
  end

  def self.queued_to_csv
    # Full name: #{x.full_name}
    # Birthday:  #{x.offenses.pluck(:date_of_birth).uniq.map{|x| x.strftime('%-m/%-d/%Y')}.join ', '}
    # Email:     #{x.email}
    # Phone:     #{x.phone}
    # Street:    #{x.street}
    # City:      #{x.city}
    # State:     #{x.state}
    # ZIP:       #{x.zip}
    # Relief message preference: #{x.relief_method}
    # Advice letter preference: #{x.advice_method}
    # Queue Date: #{x.queue_date}
    CSV.generate do |csv|
      csv << %w(Name Birthday Email Phone Street City State ZIP Relief\ Message\ Preference Advice\ Letter\ Preference Queue\ Date)

      where.not(queue_date: nil).order(queue_date: :asc).each do |x|
        name = x.full_name
        bday = x.offenses.pluck(:date_of_birth).uniq.map { |x| x.strftime('%-m/%-d/%Y') }.join '; '
        email = x.email
        phone = x.phone
        street = x.street
        city = x.city
        state = x.state
        zip = x.zip
        relief = x.relief_method
        advice = x.advice_method
        queue = x.queue_date
        csv << [name, bday, email, phone, street, city, state, zip, relief, advice, queue]
      end
    end
  end

  private

  def email_or_phone
    unless email.blank? || phone.blank?
      errors.add :email, 'or phone must be present'
    end
  end
end
