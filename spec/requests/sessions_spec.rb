require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) do
    user = FactoryBot.build :user
    user.password = 'sample_password'
    user.save
    user
  end

  describe "POST /create" do
    context 'when user is not found' do
      it 'returns not found status' do
        post '/sessions', params: { username: 'not_existed_username', password: 'sample_password' }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when password does not match' do
      it 'returns unprocessable status' do
        post '/sessions', params: { username: user.username, password: 'wrong_password' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when password matches' do
      it 'returns created status' do
        post '/sessions', params: { username: user.username, password: 'sample_password' }
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "POST /delete" do
    it 'returns ok status' do
      post '/sessions', params: { username: user.username, password: 'sample_password' }
      expect(response).to have_http_status(:created)

      delete "/sessions/#{user.id}"
      expect(response).to have_http_status(:ok)
    end
  end
end
