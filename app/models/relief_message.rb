class ReliefMessage < ApplicationRecord
  after_create_commit :deliver_message

  before_validation :set_body

  belongs_to :contact

  has_many :contact_histories, dependent: :destroy

  has_and_belongs_to_many :offenses

  validates :body, presence: true

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
    if offenses.all?(&:fta?)
      # render message 1
      message_1 format
    elsif offenses.all?(&:ftp?)
      if offenses.all?(&:pending?)
        # pending => message 5
        message_5 format
      elsif offenses.all?(&:approved?)
        # approved => message 2
        message_2 format
      elsif offenses.all?(&:denied?)
        # denied => message 6 (no such thing as message 6)
      end
    elsif offenses.any?(&:fta?) && offenses.any?(&:ftp?)
      ftps = offenses.select(&:ftp?)
      if ftps.all?(&:approved?)
        # ftp approved => message 3
        message_3 format
      elsif ftps.all?(&:pending?)
        # ftp pending => message 4
        message_4 format
      elsif ftps.all?(&:denied?)
        # ftp denied => missing
      end
    end
  end

  def message_1(format)
    ApplicationController.render(
      "contact_mailer/message_1.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_2(format)
    ApplicationController.render(
      "contact_mailer/message_2.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_3(format)
    ApplicationController.render(
      "contact_mailer/message_3.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_4(format)
    ApplicationController.render(
      "contact_mailer/message_4.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  def message_5(format)
    ApplicationController.render(
      "contact_mailer/message_5.#{format}", layout: nil, locals: { offenses: offenses }
    )
  end

  private

  def deliver_message
    if contact.method == 'email'
      # send email
      ContactMailer.send_message(contact_id, id).deliver_now
    elsif contact.method == 'text'
      # send text
      p 'I SHOULD SEND A TEXT MESSAGE'
    end
  end

  def set_body
    self.body = generate_email 'html'
  end
end
