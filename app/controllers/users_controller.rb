class UsersController < ApplicationController
  before_action :authenticate_user, only: [:update]

  def show
    user = User.find_by!(id: params[:id])
    render json: user, status: :ok
  end

  def update
    @current_user.update!(user_params)
    render json: @current_user, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
