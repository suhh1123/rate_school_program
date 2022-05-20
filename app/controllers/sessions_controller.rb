class SessionsController < ApplicationController
  include ActionController::Cookies

  def create
    user = User.find_by! username: params[:username]

    if user.password == params[:password]
      session[:user_id] = user.id
      cookies[:username] = user.username
      render json: user, status: :created
    else
      render json: user.errors.messages, status: :unprocessable_entity
    end
  end

  def logout
    reset_session
    render json: 'logout successfully', status: :ok
  end

  def logged_in
    if @current_user
      render json: {
        logged_in: true,
        user: @current_user
      }
    else
      render json: {
        logged_in: false
      }
    end
  end
end
