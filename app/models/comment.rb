class Comment < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user
  belongs_to :program
  has_many :favorites
  has_many :admirers, through: :favorites, source: :user
end
