class RegistrationsController < ApplicationController

  def create
    user = User.new(user_params)
    user.password = params[:password]
    user.save! # will be rescue if saving didn't succeed
    UserMailer.with(user: user).welcome_email.deliver_later
    render json: user, status: :created
  end

  private

  def user_params
    params.require(:registration).permit(:first_name, :last_name, :email, :username)
  end
end
