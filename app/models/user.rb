require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  VALID_EMAIL_REGEX= /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

  validates :email, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password_hash, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX, multiline: true }

  has_many :comments

  has_one_attached :avatar

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
