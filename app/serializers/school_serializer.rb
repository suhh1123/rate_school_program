class SchoolSerializer < ActiveModel::Serializer
  attributes :name, :address, :city, :state, :zipcode, :country
end
