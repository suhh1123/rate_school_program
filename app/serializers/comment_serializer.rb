class CommentSerializer < ActiveModel::Serializer
  attributes :title, :content, :program

  def program
    object.program.slice(:id, :title, :school)
  end
end
