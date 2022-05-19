class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password_hash, presence: true
end
