require 'spec_helper'
require 'poms/api/client'

module Poms
  module Api
    RSpec.describe Client do
      let(:uri) { Addressable::URI.parse('http://example.com/some/uri') }

      let(:credentials) do
        instance_double(
          'Credentials',
          origin: 'my origin',
          key: 'mykey',
          secret: 'mysecret'
        )
      end

      it 'uses #get to prepare and execute a GET request' do
        stub_request(:get, 'https://example.com/some/uri')
          .with(headers: { 'Origin' => 'my origin' })
          .to_return(body: 'stubbed response', status: 200)
        expect(
          described_class.execute(Poms::Api::Request.new(
            method: :get,
            uri: uri,
            credentials: credentials
          ))
        ).to eql(Poms::Api::Response.new(200, 'stubbed response', {}))
      end

      it 'uses #post to prepare and execute a POST request' do
        stub_request(:post, 'https://example.com/some/uri')
          .with(headers: { 'Origin' => 'my origin' }, body: 'my body')
          .to_return(body: 'stubbed response', status: 200)
        expect(
          described_class.execute(Poms::Api::Request.new(
            method: :post,
            uri: uri,
            body: 'my body',
            credentials: credentials
          ))
        ).to eql(Poms::Api::Response.new(200, 'stubbed response', {}))
      end

      it 'raises HttpMissingError given a 404 response' do
        stub_request(:get, 'https://example.com/some/uri')
          .to_return(status: 404)
        expect {
          described_class.execute(Poms::Api::Request.new(
            method: :get,
            uri: uri,
            credentials: credentials
          ))
        }.to raise_error(Poms::Errors::HttpMissingError)
      end

      it 'raises HttpServerError given a 500 response' do
        stub_request(:get, 'https://example.com/some/uri')
          .to_return(status: 500)
        expect {
          described_class.execute(Poms::Api::Request.new(
            method: :get,
            uri: uri,
            credentials: credentials
          ))
        }.to raise_error(Poms::Errors::HttpServerError)
      end

      it 'raises a generic HttpError when the driver fails' do
        allow(Net::HTTP).to receive(:start).and_raise(Timeout::Error)
        expect {
          described_class.execute(Poms::Api::Request.new(
            method: :get,
            uri: uri,
            credentials: credentials
          ))
        }.to raise_error(Poms::Errors::HttpError)
      end
    end
  end
end
