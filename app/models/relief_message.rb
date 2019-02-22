class ReliefMessage < ApplicationRecord
  before_validation :set_body

  belongs_to :contact

  has_many :contact_histories, dependent: :destroy

  has_and_belongs_to_many :offenses

  validates :body, presence: true

  private

  def set_body
    self.body = generate_body_text
  end

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
  def generate_body_text
    # we must determine if all the offenses are fta or ftp or both
    # we must determine if all the offenses are approved/pending/denied
    if offenses.all?(&:fta?)
      # render message 1
      message_1
    elsif offenses.all?(&:ftp?)
      if offenses.all?(&:pending?)
        # pending => message 5
        message_5
      elsif offenses.all?(&:approved?)
        # approved => message 2
        message_2
      elsif offenses.all?(&:denied?)
        # denied => message 6 (no such thing as message 6)
      end
    elsif offenses.any?(&:fta?) && offenses.any?(&:ftp?)
      ftps = offenses.select(&:ftp?)
      if ftps.all?(&:approved?)
        # ftp approved => message 3
        message_3
      elsif ftps.all?(&:pending?)
        # ftp pending => message 4
        message_4
      elsif ftps.all?(&:denied?)
        # ftp denied => missing
      end
    end
  end

  def message_1
    ApplicationController.render(
      'contact_mailer/message_1', layout: nil, locals: { offenses: offenses }
    )
  end

  def message_2
    ApplicationController.render(
      'contact_mailer/message_2', layout: nil, locals: { offenses: offenses }
    )
  end

  def message_3
    ApplicationController.render(
      'contact_mailer/message_3', layout: nil, locals: { offenses: offenses }
    )
  end

  def message_4
    ApplicationController.render(
      'contact_mailer/message_4', layout: nil, locals: { offenses: offenses }
    )
  end

  def message_5
    ApplicationController.render(
      'contact_mailer/message_5', layout: nil, locals: { offenses: offenses }
    )
  end
end
