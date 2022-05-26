class SchoolsController < ApplicationController
  def index
    if params[:country] && params[:state]
      schools = School.where(country: params[:country], state: params[:state])
    elsif params[:country]
      schools = School.where(country: params[:country])
    else
      schools = School.all
    end
    @pagy, @records = pagy(schools)
    render json: @records, status: :ok
  end

  def create
    school = School.new(school_params)
    school.save!
    render json: school, status: :created
  end

  def show
    school = School.find_by!(id: params[:id])
    render json: school, include: 'programs', status: :ok
  end

  def search
    query = Elasticsearch::DSL::Search.search do
      query do
        multi_match do
          query params[:query]
          fields ['name^10', 'city']
        end
      end
    end

    resp = School.search(query)
    schools = resp.results.map { |r| r._source }
    render json: schools, status: :ok
  end

  def upload_images
    school = School.find_by!(id: params[:id])
    if params[:images].present?
      params[:images].each do |image|
        school.images.attach(image)
      end
    end
    render json: school, status: :ok
  end

  private

  def school_params
    params.require(:school).permit(:name, :address, :city, :state, :zipcode, :country)
  end
end
