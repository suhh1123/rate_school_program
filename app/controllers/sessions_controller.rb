class SessionsController < ApplicationController
  include ActionController::Cookies

  def create
    user = User.find_by! username: params[:username]

    if user.password == params[:password]
      session[:user_id] = user.id
      cookies[:username] = user.username
      render json: user, status: :created
    else
      render json: { login: false }, status: :unprocessable_entity
    end
  end

  def logout
    reset_session
    cookies.delete :username
    render json: { logout: true }, status: :ok
  end

  def logged_in
    if @current_user
      render json: @current_user
    else
      render json: {
        logged_in: false
      }
    end
  end
end
