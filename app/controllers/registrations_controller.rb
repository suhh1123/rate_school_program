class RegistrationsController < ApplicationController

  def create
    user = User.new(user_params)
    user.password = params[:password]
    user.save! # will be rescue if saving didn't succeed
    session[:user_id] = user.id
    render json: user, status: :created
  end

  private

  def user_params
    params.require(:registration).permit(:first_name, :last_name, :email, :username)
  end
end
