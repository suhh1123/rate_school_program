class CommentSerializer < ActiveModel::Serializer
  type :comment

  attributes :title, :content

  has_one :program
  has_one :user
end
