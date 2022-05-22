class SchoolsController < ApplicationController
  after_action { pagy_headers_merge(@pagy) if @pagy }

  def index
    if params[:country] && params[:state]
      schools = School.where(country: params[:country], state: params[:state])
    elsif params[:country]
      schools = School.where(country: params[:country])
    else
      schools = School.all
    end
    @pagy, @records = pagy(schools)
    render json: @records
  end

  def create
    school = School.new(school_params)
    school.save!
    render json: school, status: :created
  end

  def show
    school = School.find_by!(id: params[:id])
    render json: school, status: :ok
  end

  private

  def school_params
    params.require(:school).permit(:name, :address, :city, :state, :zipcode, :country)
  end
end
