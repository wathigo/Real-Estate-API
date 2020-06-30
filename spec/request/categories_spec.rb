require 'rails_helper'

RSpec.describe 'Category API', type: :request do
  # initialize test data
  let(:category) { FactoryBot.create(:category) }
  let(:user) { FactoryBot.create(:user) }
  let(:category_id) { category.id }
  let(:user_id) { user.id }
  let(:headers) { valid_headers }
  let(:headers_without_content) { valid_headers_without_content_type }

  describe 'GET /categories' do
    before { get '/categories', params: {}, headers: headers }

    it 'returns categories' do
      FactoryBot.create(:category)
      expect(Category.count).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /categories/:id
  describe 'GET /categories/:id' do
    before { get "/categories/#{category_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the category' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(category_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:category_id) { 100 }

      it 'returns status code 404' do
        expect(json['status']).to eq(404)
      end

      it 'returns a not found message' do
        expect(json['Message']).to match('Record not Found!')
      end
    end
  end

  # Test suite for POST /categories
  describe 'POST /categories' do
    # valid payload
    let(:valid_attributes) { { category: { name: Faker::Lorem.word } } }

    context 'when the request is valid' do
      before { post '/categories', params: valid_attributes, headers: headers_without_content }

      it 'creates a category' do
        expect(json['name']).to eq(valid_attributes[:category][:name])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/categories', params: { category: { name: '' } }, headers: headers_without_content }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"name\":[\"can't be blank\"]}")
      end
    end
  end

  # Test suite for PUT /categories/:id
  describe 'PUT /categories/:id' do
    let(:valid_attributes) { { category: { name: 'Shopping' } } }

    context 'when the record exists' do
      before { put "/categories/#{category_id}", params: valid_attributes, headers: headers_without_content }

      it 'updates the record' do
        expect(response.body).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /categories/:id
  describe 'DELETE /categories/:id' do
    before { delete "/categories/#{category_id}", headers: headers_without_content }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
