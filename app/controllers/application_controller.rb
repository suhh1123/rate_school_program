class ApplicationController < ActionController::API
  before_action :set_current_user

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  private

  def record_not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def record_invalid(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def parameter_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def set_current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end
end
