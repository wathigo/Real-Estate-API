require 'rails_helper'

RSpec.describe 'Category API', type: :request do
  # initialize test data
  let(:category) { FactoryBot.create(:category) }
  let(:user) { FactoryBot.create(:user) }

  # Test suite for POST /users
  describe 'POST /auth/signup' do
    # valid payload
    let(:valid_attributes) { { user: { name: Faker::Name.name, email: Faker::Internet.email, password: 'foobar' } } }

    context 'when the request is valid' do
      before { post '/auth/signup', params: valid_attributes}

      it 'creates a user' do
        expect(json['email']).to eq(valid_attributes[:user][:email])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post '/auth/signup', params: { user: { name: '', email: Faker::Internet.email, password: 'foobar' }}}

      it 'returns status code 422' do
        expect(json['status']).to eq(422)
      end

      it 'returns a validation failure message' do
        expect(json['error'])
          .to match({"name"=>["can't be blank"]})
      end
    end
  end  
end
