class UserSerializer < ActiveModel::Serializer
  type :user
  attributes :first_name, :last_name, :email, :username
end
