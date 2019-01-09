class Offense < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :street_address, presence: true
  validates :type, presence: true
  validates :status, presence: true
end
