class Contact < ApplicationRecord
  belongs_to :offense
  validates :type, presence: true
  validates :info, presence: true
end
