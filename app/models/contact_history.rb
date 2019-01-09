class ContactHistory < ApplicationRecord
  belongs_to :contact
  belongs_to :offense
  belongs_to :reliefmessage
end
