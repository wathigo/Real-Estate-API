require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { FactoryBot.create(:user) }
  # valid request subject
  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  # invalid request subject
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  describe '#call' do
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end

    # raise Authentication Error when invalid request
    context 'when invalid credentials' do
      it 'raises an authentication error' do
        response = invalid_auth_obj.call
        expect response.errors.should be_an_instance_of(SimpleCommand::Errors)
      end
    end
  end
end
