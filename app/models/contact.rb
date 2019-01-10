class Contact < ApplicationRecord
  belongs_to :offense
  has_many :relief_messages
  has_many :contact_histories
  validates :type, presence: true
  validates :info, presence: true
end
