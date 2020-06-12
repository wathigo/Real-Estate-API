require 'rails_helper'

RSpec.describe 'Property API', type: :request do
  # initialize test data
  let(:category) { FactoryBot.create(:category) }
  let(:category_id) { category.id }
  let(:property) { FactoryBot.create(:property, category_id: category_id) }
  let(:user) { FactoryBot.create(:user) }
  let(:property_id) { property.id }
  let(:user_id) { user.id }
  let(:headers) { valid_headers }
  let(:headers_without_content) { valid_headers_without_content_type }

  before do
    FactoryBot.create(:favourite, property_id: property.id, user_id: user.id)
    FactoryBot.create(:geo_location, property_id: property.id)
  end

  describe 'GET /properties' do
    before { get '/properties', params: {}, headers: headers }

    it 'returns properties' do
      expect(Property.count).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /properties/:id
  describe 'GET /properties/:id' do
    before { get "/properties/#{property_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the property' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(property_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:property_id) { 100 }

      it 'returns status code 404' do
        expect(json['status']).to eq(404)
      end

      it 'returns a not found message' do
        expect(json['Message']).to match('Record not Found!')
      end
    end
  end

  # Test suite for POST /properties
  describe 'POST /properties' do
    # valid payload

    let(:valid_attributes) { FactoryBot.attributes_for(:property) }

    context 'when the request is valid' do
      before { # rubocop:disable Style/BlockDelimiters
        valid_attributes[:category_id] = category_id
        post '/properties', params: { property: valid_attributes }, headers: headers_without_content
      }

      it 'creates a property' do
        expect(json['address']).to eq(valid_attributes[:address])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/properties', params: { property: { name: '' } }, headers: headers_without_content }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match("{\"category\":[\"must exist\"],\"address\":[\"can't be blank\"],\"description\":[\"can't be blank\"],\"price\":[\"can't be blank\"]}") # rubocop:disable Layout/LineLength
      end
    end
  end

  # Test suite for PUT /properties/:id
  describe 'PUT /properties/:id' do
    let(:valid_attributes) { { property: { name: 'Shopping' } } }

    context 'when the record exists' do
      before { put "/properties/#{property_id}", params: valid_attributes, headers: headers_without_content }

      it 'updates the record' do
        expect(response.body).not_to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /properties/:id
  describe 'DELETE /properties/:id' do
    before { delete "/properties/#{property_id}", headers: headers_without_content }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  # Test suite for Put /add_geo_location
  describe 'PUT /add_geo_location' do
    before { put '/add_geo_location', params: { id: property_id, latt: 86_248, long: 824_628 }, headers: headers_without_content } # rubocop:disable Layout/LineLength

    context 'When property record exists' do
      it 'Returns geolocation record' do
        expect(json['property_id']).to eq(property_id)
      end

      it 'Returns a HTTP status of 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "When Property record does not exist" do
      let(:property_id) { 200 }
      it 'Returns Must contain property' do
        expect(json['error']).to eq('Property not found')
      end

      it 'Returns a http status of 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'get /geo_location' do
    before { get '/geo_location', params: { id: property_id }, headers: headers }

    context 'When valid parameters have been passed' do
      it 'Returns a property record' do
        expect(json['property_id']).to eq(property_id)
      end

      it 'Returns a status of 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'When geo does not exists' do
      let(:property_id) { 700 }
      it 'Return an error message' do
        expect(json['error']).to eq('Property not Found')
      end

      it 'Returns a status of 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'put /add_favourites' do
    before { put '/add_favourites', params: { id: property_id }, headers: headers_without_content }

    context 'When property exists' do
      it 'Returns a favorite record' do
        expect(json['property_id']).to eq(property_id)
      end

      it 'Returns a status of 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'When property does not exist' do
      let(:property_id) { 82_478 }
      it 'Returns a error message' do
        expect(json['error']).to eq('Property not Found')
      end

      it 'Returns a status of 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'get /my_favourites' do
    before { get '/my_favourites', params: { id: property_id }, headers: headers }

    it "Returns an array of current_user's favourite properties" do
      expect(json).to be_an_instance_of(Array)
    end

    it 'Returns a status of 200' do
      expect(response).to have_http_status(200)
    end
  end
end
