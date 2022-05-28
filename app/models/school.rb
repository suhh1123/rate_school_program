class School < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :zipcode, format: { with: /\A[0-9]{5}(?:-[0-9]{4})?\z/ }

  has_many :programs

  has_many_attached :images

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :name, analyzer: 'english'
      indexes :city, analyzer: 'english'
    end
  end
end