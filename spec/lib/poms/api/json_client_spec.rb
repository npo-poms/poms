require 'spec_helper'
require 'poms/api/json_client'

module Poms
  module Api
    RSpec.describe JsonClient do
      let(:uri) { Addressable::URI.parse('http://example.com/some/uri') }
      let(:credentials) do
        double(
          'Credentials',
          origin: 'my origin',
          key: 'mykey',
          secret: 'mysecret'
        )
      end

      it 'formats outgoing POST requests as JSON' do
        stub_request(:post, 'https://example.com/some/uri').to_return(body: "{}")
        described_class.post(uri, { 'key' => 'value' }, credentials)
        expect(WebMock).to have_requested(
          :post,
          'https://example.com/some/uri'
        ).with(
          body: '{"key":"value"}',
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'parses incoming POST responses as JSON' do
        stub_request(
          :post,
          'https://example.com/some/uri'
        ).with(
          body: '{"key":"value"}',
          headers: { 'Accept' => 'application/json' }
        ).to_return(
          body: '{"foo":"bar"}',
          status: 200
        )
        response = described_class.post(uri, { 'key' => 'value' }, credentials)
        expect(response).to eql("foo" => "bar")
      end

      it 'formats outgoing GET requests as JSON' do
        stub_request(:get, 'https://example.com/some/uri').to_return(body: "{}")
        described_class.get(uri, credentials)
        expect(WebMock).to have_requested(
          :get,
          'https://example.com/some/uri'
        ).with(
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'parses incoming GET responses as JSON' do
        stub_request(
          :get,
          'https://example.com/some/uri'
        ).with(
          headers: { 'Accept' => 'application/json' }
        ).to_return(
          body: '{"foo":"bar"}',
          status: 200
        )
        response = described_class.get(uri, credentials)
        expect(response).to eql("foo" => "bar")
      end
    end
  end
end
