class SessionsController < ApplicationController

  def create
    user = User.find_by! username: params[:username]

    if user.password == params[:password]
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: user.errors.messages, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { message: 'logout successfully'}, status: :ok
  end
end
