class SchoolSerializer < ActiveModel::Serializer
  attributes :name, :address, :city, :state, :zipcode, :country, :programs

  class ProgramSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

  def programs
    object.programs.map do |program|
      ProgramSerializer.new(program).attributes
    end
  end
end
