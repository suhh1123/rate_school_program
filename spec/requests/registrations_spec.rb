require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  let(:user) do
    user = FactoryBot.build :user
    user.password = 'sample_password'
    user.save
    user
  end

  describe "Post /create" do
    context 'when required parameter is missing' do
      it 'returns unprocessable status' do
        post '/registrations', params: {
          registration: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: 'second-sample@example.com',
            password: user.password
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json). to eq(
                           {
                             error: "Validation failed: Username can't be blank"
                           }
                         )
      end
    end

    context 'when duplicate value is passed to unique attribute' do
      it 'returns unprocessable status' do
        post '/registrations', params: {
          registration: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email,
            username: user.username,
            password: user.password
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json).to eq(
                          {
                            error: "Validation failed: Email has already been taken, Username has already been taken"
                          }
                        )
      end
    end

    context 'when user is created successfully' do
      it 'returns created status' do
        post '/registrations', params: {
          registration: {
            first_name: 'sample_f_name_2',
            last_name: 'sample_l_name_2',
            email: 'sample-email-2@example.com',
            username: 'sample_username_2',
            password: 'sample_password_2'
          }
        }
        expect(response).to have_http_status(:created)
        expected = json_data
        expect(expected[:type]).to eq('user')
        expect(expected[:attributes]).to include({
                                              "first-name": 'sample_f_name_2',
                                              "last-name": 'sample_l_name_2',
                                              email: 'sample-email-2@example.com',
                                              username: 'sample_username_2'
                                            })
      end
    end
  end
end
