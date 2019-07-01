class Admin < ApplicationRecord
  after_create :send_invite_email

  before_create :set_token

  # Include default devise modules. Others available are:
  # :confirmable,:lockable, :timeoutable, :trackable, :omniauthable, validatable
  devise :database_authenticatable,
         :recoverable, :rememberable

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: Devise.email_regexp

  validates_presence_of     :password, on: :update
  validates_confirmation_of :password, on: :update

  private

  def send_invite_email
    AdminMailer.send_invite(id).deliver_now
  end

  def set_token
    self.token = SecureRandom.urlsafe_base64 4
    while Admin.find_by_token token
      self.token = SecureRandom.urlsafe_base64 4
    end
  end
end
