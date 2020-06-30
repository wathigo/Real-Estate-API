require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  # Create test user
  let(:user) { FactoryBot.create(:user) }
  # Mock `Authorization` header
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  # Invalid request subject
  subject(:invalid_request_obj) { described_class.new({}) }
  # Valid request subject
  subject(:request_obj) { described_class.new(header) }

  # Test Suite for AuthorizeApiRequest#call
  # This is our entry point into the service class
  describe '#call' do
    # returns user object when request is valid
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call
        expect(result.successful?).to eq(true)
      end
    end

    # returns error message when invalid request
    context 'when invalid request' do # rubocop:disable Metrics/BlockLength:
      context 'when missing token' do
        it 'raises a MissingToken error' do
          response = invalid_request_obj.call
          expect(response.errors).to be_an_instance_of(SimpleCommand::Errors)
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) do
          # custom helper method `token_generator`
          described_class.new('Authorization' => token_generator(5))
        end

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it 'raises ExceptionHandler::ExpiredSignature error' do
          expect(request_obj.call.errors)
            .to be_an_instance_of(
              SimpleCommand::Errors
            )
        end
      end

      context 'fake token' do
        let(:header) { { 'Authorization' => 'foobar' } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it 'handles JWT::DecodeError' do
          expect(invalid_request_obj.call.errors)
            .to be_an_instance_of(
              SimpleCommand::Errors
            )
        end
      end
    end
  end
end
