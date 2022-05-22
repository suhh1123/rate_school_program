require 'rails_helper'

RSpec.describe "Programs", type: :request do
  describe "GET /index" do
    context 'when the school does not exist' do
      it 'returns a not-found error' do
        get '/schools/1/programs'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the school exist' do
      let(:programs) do
        school = FactoryBot.create :school
        count = 3
        programs = FactoryBot.build_list :program, count
        count.times do |i|
          programs[i].school = school
          programs[i].save
        end
        programs
      end

      it 'returns a proper JSON' do
        program = programs[0]
        get "/schools/#{program.school_id}/programs"
        expect(response).to have_http_status(:ok)
        expected = json_data.first
        expect(expected[:id]).to eq(program.id.to_s)
        expect(expected[:type]).to eq('programs')
        expect(expected[:attributes]).to eq({
                                               title: program.title
                                             })
      end

      it 'paginates results' do
        get "/schools/#{programs[0].school_id}/programs"
        expect(response.header["Page-Items"]).to eq(json_data.length.to_s)
      end

      it 'contains pagination links in the header' do
        get "/schools/#{programs[0].school_id}/programs"
        expect(response.header).to have_key("Link")
      end
    end
  end

  describe "POST /create" do
    let(:program_params) {
      {
        program: {
          title: 'sample_title'
        }
      }
    }

    let(:school) { school = FactoryBot.create :school }

    let(:program) do
      program = FactoryBot.build :program
      program.school = school
      program.save
      program
    end

    context 'when the school does not exist' do
      it 'returns a not-found error' do
        post "/schools/#{school.id + 1}/programs", params: program_params
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when both title and school have already existed' do
      it 'returns a unprocessable-entity error' do
        program_params[:program][:title] = program.title
        post "/schools/#{school.id}/programs", params: program_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the title is missing' do
      it 'returns a unprocessable-entity error' do
        program_params[:program].delete(:title)
        post "/schools/#{school.id}/programs", params: program_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when program params and school id are all valid and not missing' do
      it 'returns a created status' do
        expect{ post "/schools/#{school.id}/programs", params: program_params }.to change {Program.count}.from(0).to(1)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "GET /show" do
    let(:school) { school = FactoryBot.create :school }

    let(:program) do
      program = FactoryBot.build :program
      program.school = school
      program.save
      program
    end

    context 'when the school and program do not exist' do
      it 'returns a not-found error' do
        get "/schools/#{school.id + 1}/programs/#{program.id}"
        expect(response).to have_http_status(:not_found)

        get "/schools/#{school.id}/programs/#{program.id + 1}"
        expect(response).to have_http_status(:not_found)

        get "/schools/#{school.id + 1}/programs/#{program.id + 1}"
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the school and program exist' do
      it 'returns a ok status' do
        get "/schools/#{school.id}/programs/#{program.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
