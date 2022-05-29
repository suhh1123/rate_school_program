class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  type :user
  attributes :id, :first_name, :last_name, :email, :username, :avatar

  def avatar
    if object.avatar.attached?
      {
        url: rails_blob_url(object.avatar)
      }
    end
  end
end
