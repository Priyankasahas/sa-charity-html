require 'spec_helper'
require 'authenticates_users'
require 'faraday'
require 'faraday_middleware'

RSpec.describe AuthenticatesUsers do
  context '.authenticate' do
    let(:service) { double(:service, endpoint: 'http://localhost:4000', username: 'sai', password: 'password') }

    context 'given valid credentials' do
      let(:email) { 'priyanka.sahas@live.com' }
      let(:password) { 'Pri12345' }
      let(:model) { class_double('User').as_stubbed_const }

      it 'should return the user' do
        VCR.use_cassette('authentication_valid_user') do
          expect(model).to receive(:build) { |args| OpenStruct.new(args) }

          user = AuthenticatesUsers.authenticate(service, email, password)
          expect(user.email).to eq(email)
        end
      end
    end

    context 'given invalid credentials' do
      let(:email) { 'bob@example.com' }
      let(:password) { '12312' }

      it 'should return nil' do
        VCR.use_cassette('authentication_invalid_user') do
          expect(AuthenticatesUsers.authenticate(service, email, password)).to eq nil
        end
      end
    end
  end
end
