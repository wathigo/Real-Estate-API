require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
  # initialize test data
  let(:user) { FactoryBot.create(:user) }

  # Test suite for POST /users
  describe 'POST /authenticate' do
    context 'when the request is valid' do
      before { post '/authenticate', params: { email: user.email, password: user.password } }

      it 'Returns auth token' do
        expect(json['auth_token']).not_to be_nil
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post '/authenticate', params: { email: "unknown@gmail.com", password: "foobar" } }

      it 'returns status code 422' do
        expect(response).to have_http_status(401)
      end

      it 'returns a validation failure message' do
        expect(json['error'])
          .to match({ "user_authentication" => "invalid credentials" })
      end
    end
  end
end
