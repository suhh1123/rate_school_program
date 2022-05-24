class SchoolSerializer < ActiveModel::Serializer
  type :school

  attributes :name, :address, :city, :state, :zipcode, :country

  class ProgramSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

  has_many :programs
end
