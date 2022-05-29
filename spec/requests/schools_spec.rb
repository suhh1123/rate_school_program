require 'rails_helper'

RSpec.describe "Schools", type: :request do
  describe "GET /index" do
    context 'no filter is passed' do
      it 'returns a proper JSON' do
        school = FactoryBot.create :school
        get '/schools'
        expect(response).to have_http_status(:ok)
        expected = JSON.parse(response.body).first.deep_symbolize_keys
        expect(expected).to include(
                              {
                                name: school.name,
                                address: school.address,
                                city: school.city,
                                state: school.state,
                                zipcode: school.zipcode,
                                country: school.country
                              }
                            )
      end

      it 'paginates results' do
        school1, school2, school3 = FactoryBot.create_list :school, 3
        get '/schools'
        expect(response.header["Page-Items"]).to eq(JSON.parse(response.body).length.to_s)
      end

      it 'contains pagination links in the header' do
        school1, school2, school3 = FactoryBot.create_list :school, 3
        get '/schools'
        expect(response.header).to have_key("Link")
      end
    end

    context 'filter country' do
      it 'returns schools with the specific country' do
        first_school = FactoryBot.create :school, country: 'United State'
        second_school = FactoryBot.create :school, country: 'China'
        get '/schools', params: { country: first_school.country }
        expect(response).to have_http_status(:ok)
        expected = JSON.parse(response.body)
        expect(expected.size).to eq(1)
      end
    end

    context 'filter country and state' do
      it 'returns schools with the specific country and state' do
        first_school= FactoryBot.create :school, country: 'United State', state: 'NY'
        second_school = FactoryBot.create :school, country: 'United State', state: 'CA'
        get '/schools', params: { country: first_school.country, state: first_school.state }
        expect(response).to have_http_status(:ok)
        expected = JSON.parse(response.body)
        expect(expected.size).to eq(1)
      end
    end
  end

  describe "POST /create" do
    let(:school_params) {
      {
        school: {
          name: 'sample_name',
          address: 'sample_address',
          city: 'sample_city',
          state: 'sample_state',
          zipcode: 10027,
          country: 'sample_country'
        }
      }
    }

    context 'when school name is missing' do
      it 'returns a unprocessable_entity error' do
        school_params[:school].delete(:name)
        post '/schools', params: school_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:error]).to include("Name can't be blank")
      end
    end

    context 'when school name has already existed' do
      it 'returns a unprocessable_entity error' do
        school = FactoryBot.create :school
        school_params[:school][:name] = school.name
        post '/schools', params: school_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:error]).to include("Name has already been taken")
      end
    end

    context 'when school params are all valid and not missing' do
      it 'returns a created status' do
        expect {
          post '/schools', params: school_params
        }.to change {School.count}.from(0).to(1)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "GET /show" do
    context 'when the given id is invalid' do
      it 'returns a not-found error' do
        FactoryBot.create :school
        get '/schools/10'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the given id is valid' do
      it 'returns a ok status' do
        school = FactoryBot.create :school
        get "/schools/#{school.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
