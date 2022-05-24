class ProgramSerializer < ActiveModel::Serializer
  type :program

  attributes :title

  has_one :school
end
