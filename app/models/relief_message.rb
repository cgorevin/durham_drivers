class ReliefMessage < ApplicationRecord
  belongs_to :contact
  validates :body, presence: true
end
