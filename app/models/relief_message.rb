class ReliefMessage < ApplicationRecord
  belongs_to :contact

  has_many :contact_histories

  has_and_belongs_to_many :offenses

  validates :body, presence: true
end
