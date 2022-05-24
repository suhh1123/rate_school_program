class UsersController < ApplicationController
  before_action :authenticate_user, only: [:update, :upload_avatar]

  def show
    user = User.find_by!(id: params[:id])
    render json: user, status: :ok
  end

  def update
    @current_user.update!(user_update_params)
    render json: @current_user, status: :ok
  end

  def upload_avatar
    @current_user.update!(user_upload_avatar_params)
    render json: @current_user, status: :ok
  end

  private

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  def user_upload_avatar_params
    params.permit(:avatar)
  end
end
