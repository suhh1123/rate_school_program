class Program < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: :school, case_sensitive: false }

  belongs_to :school
  has_many :comments
end
