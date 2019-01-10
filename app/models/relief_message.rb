class ReliefMessage < ApplicationRecord
  belongs_to :contact
  has_many :contact_histories
  validates :body, presence: true
end
