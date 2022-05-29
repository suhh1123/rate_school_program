require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) do
    user = FactoryBot.build :user
    user.password = 'sample_password'
    user.save
    user
  end

  describe "GET /show" do
    context 'when the user does not exist' do
      it 'returns a not-found error' do
        get "/users/#{user.id + 1}"
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the user exists' do
      it 'returns an ok status' do
        get "/users/#{user.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PUT /update" do
    let(:user_params) {
      {
        user: {
          first_name: 'modified_f_name',
          last_name: 'modified_l_name',
          email: 'modified@example.com'
        }
      }
    }

    context "when user didn't login" do
      it 'returns an unauthorized error' do
        put "/users/#{user.id}", params: user_params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user logged in' do
      before do
        post "/sessions", params: {username: user.username, password: 'sample_password'}
      end

      context 'when the email has already been taken' do
        it 'returns an unprocessable-entity error' do
          second_user = FactoryBot.build :user
          second_user.password = 'sample_password'
          second_user.save

          user_params[:user][:email] = second_user.email
          put "/users/#{user.id}", params: user_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when the email has not been taken' do
        it 'returns an ok status' do
          put "/users/#{user.id}", params: user_params
          expect(response).to have_http_status(:ok)
          expected = JSON.parse(response.body).deep_symbolize_keys
          expect(expected).to include(
                                {
                                  first_name: user_params[:user][:first_name],
                                  last_name: user_params[:user][:last_name],
                                  email: user_params[:user][:email],
                                  username: user.username
                                }
                              )
        end
      end
    end
  end
end
