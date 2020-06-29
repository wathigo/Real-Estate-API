require 'rails_helper'

RSpec.describe 'Category API', type: :request do
  # initialize test data
  let(:category) { FactoryBot.create(:category) }
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) { { user: { name: Faker::Name.name, email: Faker::Internet.email, password: 'foobar' } } }
  let(:headers) { valid_headers }

  # Test suite for POST /users
  describe 'POST /auth/signup' do
    context 'when the request is valid' do
      before { post '/auth/signup', params: valid_attributes }

      it 'creates a user' do
        expect(json['auth_token']).not_to be_nil
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post '/auth/signup', params: { user: { name: '', email: Faker::Internet.email, password: 'foobar' } } }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a validation failure message' do
        expect(json['error'])
          .to match({ 'name' => ["can't be blank"] })
      end
    end
  end

  describe 'get /user' do
    before { get '/user', headers: headers }
    context 'When user has been authenticated' do
      it 'Retuns the current user' do
        expect(json['email']).to eq(user.email)
      end

      it 'Returns a status of 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'When user has not been authenticated' do
      let(:headers) { invalid_headers }
      it 'Returns an error message' do
        expect(json['error']).to eq('Not Authorized')
      end

      it 'Returns a status of 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
