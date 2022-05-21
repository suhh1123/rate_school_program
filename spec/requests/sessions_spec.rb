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
        expect(json).to include(login: false)
      end
    end

    context 'when password matches' do
      it 'sets up the session and cookies then returns created status' do
        post '/sessions', params: { username: user.username, password: 'sample_password' }
        expect(session[:user_id]).to eq(user.id)
        expect(cookies[:username]).to eq(user.username)
        expect(response).to have_http_status(:created)
        expected = json_data
        expect(expected[:type]).to eq('users')
        expect(expected[:attributes]).to eq({
                                              "first-name": 'sample_f_name',
                                              "last-name": 'sample_l_name',
                                              email: 'sample_email',
                                              username: 'sample_username'
                                            })
      end
    end
  end

  describe "POST /delete" do
    it 'reset the session and cookie then returns ok status' do
      post '/sessions', params: { username: user.username, password: 'sample_password' }
      expect(response).to have_http_status(:created)

      delete '/logout'
      expect(session[:user_id]).to be_nil
      expect(cookies[:username]).to eq("") # strange, I don't know why deleting
      expect(response).to have_http_status(:ok)
      expect(json).to include(logout: true)
    end
  end

  describe "GET /logged_in" do
    context 'when user has logged in' do
      it 'returns a json data including a status as logged_in: true' do
        post '/sessions', params: { username: user.username, password: 'sample_password' }
        expect(response).to have_http_status(:created)

        get '/logged_in'
        expected = json_data
        expect(expected[:type]).to eq('users')
        expect(expected[:attributes]).to eq({
                                              "first-name": 'sample_f_name',
                                              "last-name": 'sample_l_name',
                                              email: 'sample_email',
                                              username: 'sample_username'
                                            })
      end
    end

    context 'when user has logged out' do
      it 'returns a json data including a status as logged_in: false' do
        get '/logged_in'
        expect(json).to include(logged_in: false)
      end
    end
  end
end
