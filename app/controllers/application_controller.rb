class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(e)
    render json: { errors: '404 Not Found' }, status: :not_found
  end

end
