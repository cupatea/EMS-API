class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  #  , :token_authenticatable
  # before_save :ensure_authentication_token
  validates :auth_token, uniqueness: true
  before_create :generate_authentication_token!
  has_and_belongs_to_many :events
  has_many :comments

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
end
