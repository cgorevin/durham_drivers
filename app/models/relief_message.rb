class ReliefMessage < ApplicationRecord
  after_create_commit :deliver_message

  before_validation :set_body
  before_validation :set_token

  belongs_to :contact

  has_many :contact_histories, dependent: :destroy

  has_and_belongs_to_many :offenses

  validates :body, presence: true
  validates :token, presence: true, uniqueness: true

  def generate_email(format = 'html')
    production = Rails.env.production?
    host = production ? 'secondchancedriving.org' : 'localhost:3000'
    https = production
    renderer = ApplicationController.renderer.new http_host: host, https: https
    renderer.render(
      "contact_mailer/relief_message.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  private

  def deliver_message
    if contact.relief_method == 'email'
      # send email
      ContactMailer.send_message(contact_id, id).deliver_now
    elsif contact.relief_method == 'phone'
      # send text
      url = Rails.env.production? ? 'secondchancedriving.org' : 'localhost:3000'

      acc_sid = ENV['TWILIO_ID']
      auth_tkn = ENV['TWILIO_TOKEN']
      twilio_number = ENV['TWILIO_NUMBER']

      @client = Twilio::REST::Client.new(acc_sid, auth_tkn)
      @client.messages.create(
        from: twilio_number,
        to: contact.phone,
        body: "Hi! Please view your relief details here: #{url}/m/#{token}"
      )
    end
  end

  def set_body
    self.body = generate_email 'html'
  end

  def set_token
    # number of possibilities as length of string increases
    # 1 =                64
    # 2 =             4,096 (4 thousand)
    # 3 =           262,144 (262 thousand)
    # 4 =        16,777,216 (16 million)
    # 5 =     1,073,741,824 (1 billion)
    # 6 =    68,719,476,736 (68 billion)
    # 7 = 4,398,046,511,104 (4 trillion)
    # to get a base64 string with length of 6, you need base64 with 4 bytes
    token = nil
    loop do
      token = SecureRandom.urlsafe_base64 4
      break unless ReliefMessage.find_by_token token
    end
    self.token = token
  end
end
