class ProgramSerializer < ActiveModel::Serializer
  type :program

  attributes :id, :title

  has_one :school
end
