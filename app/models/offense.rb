class Offense < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :street_address, presence: true
  validates :status, presence: true
  has_many :contacts
  has_many :contact_histories

  def fta?
    !ftp
  end

  def type
    ftp ? 'FTP' : 'FTA'
  end
end
