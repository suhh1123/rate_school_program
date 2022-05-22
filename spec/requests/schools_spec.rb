require 'rails_helper'

RSpec.describe "Schools", type: :request do
  describe "GET /index" do
    context 'no filter is passed' do
      it 'returns a success response' do
        get '/schools'
        expect(response).to have_http_status(:ok)
      end

      it 'returns a proper JSON' do
        school = FactoryBot.create :school
        get '/schools'
        expected = json_data.first
        expect(expected[:id]).to eq(school.id.to_s)
        expect(expected[:type]).to eq('schools')
        expect(expected[:attributes]).to eq(
                                          name: school.name,
                                          address: school.address,
                                          city: school.city,
                                          state: school.state,
                                          zipcode: school.zipcode,
                                          country: school.country
                                        )
      end

      it 'paginates results' do
        school1, school2, school3 = FactoryBot.create_list :school, 3
        get '/schools'
        expect(response.header["Page-Items"]).to eq(json_data.length.to_s)
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
        expected = json_data
        expect(expected.size).to eq(1)
      end
    end

    context 'filter country and state' do
      it 'returns schools with the specific country and state' do
        first_school= FactoryBot.create :school, country: 'United State', state: 'NY'
        second_school = FactoryBot.create :school, country: 'United State', state: 'CA'
        get '/schools', params: { country: first_school.country, state: first_school.state }
        expect(response).to have_http_status(:ok)
        expected = json_data
        expect(expected.size).to eq(1)
      end
    end


  end

  describe "POST /create" do

    context 'when school name is missing' do
      it 'returns an error' do
        post '/schools', params: {
          school: {
            address: 'sample_address',
            city: 'sample_city',
            state: 'sample_state',
            zipcode: 10027,
            country: 'sample_country'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:error]).to include("Name can't be blank")
      end
    end

    context 'when school name has already exists' do
      it 'returns an error' do
        school = FactoryBot.create :school
        post '/schools', params: {
          school: {
            name: school.name,
            address: 'sample_address',
            city: 'sample_city',
            state: 'sample_state',
            zipcode: 10027,
            country: 'sample_country'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:error]).to include("Name has already been taken")
      end
    end

    context 'when school params are all valid and not missing' do
      it 'returns the created school' do
        expect {
          post '/schools', params: {
            school: {
              name: 'sample_name_1',
              address: 'sample_address',
              city: 'sample_city',
              state: 'sample_state',
              zipcode: 10027,
              country: 'sample_country'
            }
          }
        }.to change {School.count}.from(0).to(1)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "GET /show" do
    context 'when the given id is invalid' do
      it 'returns an error' do
        FactoryBot.create :school
        get '/schools/10'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the given id is valid' do
      it 'returns the matched school' do
        school = FactoryBot.create :school
        get "/schools/#{school.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
