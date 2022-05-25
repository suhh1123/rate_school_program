class School < ApplicationRecord
  before_create do
    School.__elasticsearch__.create_index!
    School.import
  end

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :programs

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :name, analyzer: 'english'
      indexes :city, analyzer: 'english'
    end
  end

end