class SchoolSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  type :school

  attributes :name, :address, :city, :state, :zipcode, :country, :images

  def images
    if object.images.attached?
      object.images.map do |image|
        {
          url: rails_blob_path(image, only_path: true)
        }
      end
    end
  end

  class ProgramSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

  has_many :programs
end
