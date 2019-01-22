class Contact < ApplicationRecord
  has_and_belongs_to_many :offenses
  has_many :relief_messages
  has_many :contact_histories
  validates :method, presence: true
  validates :info, presence: true, uniqueness: true
end
