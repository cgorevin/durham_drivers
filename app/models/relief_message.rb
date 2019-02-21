class ReliefMessage < ApplicationRecord
  before_validation :set_body

  belongs_to :contact

  has_many :contact_histories

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
    elsif offenses.all?(&:ftp?)
    elsif offenses.any?(&:fta?) && offenses.any?(&:ftp?)

    end
  end
end
