require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  validates :email, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password_hash, presence: true

  has_many :comments

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
