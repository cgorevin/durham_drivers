class ReliefMessage < ApplicationRecord
  after_create_commit :deliver_message

  before_validation :set_body
  before_validation :set_token

  belongs_to :contact

  has_many :contact_histories, dependent: :destroy

  has_and_belongs_to_many :offenses

  validates :body, presence: true
  validates :token, presence: true, uniqueness: true

  # 1. FTA dismissed only               (fta approved)
  # 2. FTC eliminated only              (ftp approved)
  # 3. FTA dismissed and FTC eliminated (fta and ftp approved)
  # 4. FTA dismissed and FTC still pending (fta approved && fta)
  # 5. FTC still pending only           (ftp pending)
  # 6. FTC remittance denied            (ftp denied) << no letters for these
  # remember that fta will always be approved, eliminates the possibility of fta being denied
  # fta approved                (1)
  # ftp pending                 (5)
  # ftp approved                (2)
  # ftp denied                  (6)
  # fta approved, ftp approved  (3)
  # fta approved, ftp pending   (4)
  # fta approved, ftp denied    (missing)
  def generate_email(format = 'html')
    # we must determine if all the offenses are fta or ftp or both
    # we must determine if all the offenses are approved/pending/denied
    message_6 format
    # if offenses.all?(&:fta?)
    #   # render message 1
    #   message_1 format
    # elsif offenses.all?(&:ftp?)
    #   if offenses.all?(&:pending?)
    #     # pending => message 5
    #     message_5 format
    #   elsif offenses.all?(&:approved?)
    #     # approved => message 2
    #     message_2 format
    #   elsif offenses.all?(&:denied?)
    #     # denied => message 6 (no such thing as message 6)
    #   end
    # elsif offenses.any?(&:fta?) && offenses.any?(&:ftp?)
    #   ftps = offenses.select(&:ftp?)
    #   if ftps.all?(&:approved?)
    #     # ftp approved => message 3
    #     message_3 format
    #   elsif ftps.all?(&:pending?)
    #     # ftp pending => message 4
    #     message_4 format
    #   elsif ftps.all?(&:denied?)
    #     # ftp denied => missing
    #   end
    # end
  end

  def message_1(format)
    host = Rails.env.production? ? 'second-chance-driving.herokuapp.com' : 'localhost:3000'
    https = Rails.env.production?
    renderer = ApplicationController.renderer.new(http_host: host, https: https)
    renderer.render(
      "contact_mailer/message_1.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_2(format)
    host = Rails.env.production? ? 'second-chance-driving.herokuapp.com' : 'localhost:3000'
    https = Rails.env.production?
    renderer = ApplicationController.renderer.new(http_host: host, https: https)
    renderer.render(
      "contact_mailer/message_2.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_3(format)
    host = Rails.env.production? ? 'second-chance-driving.herokuapp.com' : 'localhost:3000'
    https = Rails.env.production?
    renderer = ApplicationController.renderer.new(http_host: host, https: https)
    renderer.render(
      "contact_mailer/message_3.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_4(format)
    host = Rails.env.production? ? 'second-chance-driving.herokuapp.com' : 'localhost:3000'
    https = Rails.env.production?
    renderer = ApplicationController.renderer.new(http_host: host, https: https)
    renderer.render(
      "contact_mailer/message_4.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_5(format)
    host = Rails.env.production? ? 'second-chance-driving.herokuapp.com' : 'localhost:3000'
    https = Rails.env.production?
    renderer = ApplicationController.renderer.new(http_host: host, https: https)
    renderer.render(
      "contact_mailer/message_5.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_6(format)
    host = Rails.env.production? ? 'secondchancedriving.org' : 'localhost:3000'
    https = Rails.env.production?
    renderer = ApplicationController.renderer.new http_host: host, https: https
    renderer.render(
      "contact_mailer/relief_message.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  private

  def deliver_message
    if contact.method == 'email'
      # send email
      ContactMailer.send_message(contact_id, id).deliver_now
    elsif contact.method == 'phone'
      # send text
      url = Rails.env.production? ? 'secondchancedriving.org' : 'localhost:3000'

      acc_sid = ENV['TWILIO_ID']
      auth_tkn = ENV['TWILIO_TOKEN']

      @client = Twilio::REST::Client.new(acc_sid, auth_tkn)
      @client.messages.create(
        from: '+19193553993',
        to: contact.info,
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
