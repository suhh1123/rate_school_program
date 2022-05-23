require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe "GET /index" do
    context 'when the program does not exist' do
      it 'returns a not-found error' do
        get '/programs/1/comments'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the program exists' do
      let(:comments) do
        school = FactoryBot.create :school
        program = FactoryBot.create :program, school: school
        user = FactoryBot.build :user
        user.password = 'sample_password'
        user.save
        count = 3
        comments = FactoryBot.build_list :comment, count
        count.times do |i|
          comments[i].user = user
          comments[i].program = program
          comments[i].save
        end
        comments
      end

      it 'returns a proper JSON' do
        comment = comments[0]
        get "/programs/#{comment.program_id}/comments"
        expect(response).to have_http_status(:ok)
        expected = json_data.first
        expect(expected[:id]).to eq(comment.id.to_s)
        expect(expected[:type]).to eq('comments')
        expect(expected[:attributes]).to eq({
                                              title: comment.title,
                                              content: comment.content
                                            })
      end

      it 'paginates results' do
        get "/programs/#{comments[0].program_id}/comments"
        expect(response.header["Page-Items"]).to eq(json_data.length.to_s)
      end

      it 'contains pagination links in the header' do
        get "/programs/#{comments[0].program_id}/comments"
        expect(response.header).to have_key("Link")
      end
    end
  end

  describe "POST /create" do
    let(:comment_params) {
      {
        comment: {
          title: 'sample_title',
          content: 'sample_content'
        }
      }
    }

    let(:school) { FactoryBot.create :school }

    let(:program) do
      program = FactoryBot.build :program
      program.school = school
      program.save
      program
    end

    let(:user) do
      user = FactoryBot.build :user
      user.password = 'sample_password'
      user.save
      user
    end

    let(:comment) do
      comment = FactoryBot.build :comment
      comment.program = program
      comment.user = user
      comment.save
      comment
    end

    context "when user didn't login" do
      it 'returns an unauthorized error' do
        post "/programs/1/comments", params: comment_params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user logged in' do
      # can't find a better way to mock login, make a login request directly instead for now
      before do
        post "/sessions", params: {username: user.username, password: 'sample_password'}
      end

      context 'when the program does not exist' do
        it 'returns a not-found error' do
          post "/programs/#{program.id + 1}/comments", params: comment_params
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when the title is missing' do
        it 'returns a unprocessable-entity error' do
          comment_params[:comment].delete(:title)
          post "/programs/#{program.id}/comments", params: comment_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when the content is missing' do
        it 'returns a unprocessable-entity error' do
          comment_params[:comment].delete(:content)
          post "/programs/#{program.id}/comments", params: comment_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when comment params and program id are all valid and not missing' do
        it 'returns a created status' do
          expect{ post "/programs/#{program.id}/comments", params: comment_params }.to change {Comment.count}.from(0).to(1)
          expect(response).to have_http_status(:created)
        end
      end
    end
  end

  describe "GET /show" do
    let(:school) { FactoryBot.create :school }

    let(:program) do
      program = FactoryBot.build :program
      program.school = school
      program.save
      program
    end

    let(:user) do
      user = FactoryBot.build :user
      user.password = 'sample_password'
      user.save
      user
    end

    let!(:comment) do
      comment = FactoryBot.build :comment
      comment.program = program
      comment.user = user
      comment.save
      comment
    end

    context 'when the comment id param is provided' do
      context 'when the comment does not exist' do
        it 'returns a not-found error' do
          pp comment
          get "/comments/#{comment.id + 1}"
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when the comment exists' do
        it 'returns a ok status' do
          get "/comments/#{comment.id}"
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when the program id param is not provided' do
      it 'returns all comments in pagination' do
        get "/comments"
        expect(response).to have_http_status(:ok)
        expect(json_data.length).to eq(1)
      end
    end
  end
end
