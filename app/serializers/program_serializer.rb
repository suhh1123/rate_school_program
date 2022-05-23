class ProgramSerializer < ActiveModel::Serializer
  attributes :title, :school

  def school
    object.school.slice(:id, :name)
  end
end
