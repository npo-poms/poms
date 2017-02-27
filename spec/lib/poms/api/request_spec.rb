require 'spec_helper'

module Poms
  module Api
    RSpec.describe Request do
      it 'requires a valid HTTP method' do
        expect {
          described_class.new(method: 'bla', uri: 'uri')
        }.to raise_error(ArgumentError, 'method should be :get or :post')

        expect {
          described_class.new(method: 'get', uri: 'uri')
        }.not_to raise_error
      end

      it 'indicates whether it is a get or post request' do
        expect(described_class.new(method: :get, uri: 'uri')).to be_get
        expect(described_class.new(method: :post, uri: 'uri')).to be_post
      end

      it 'can read header values' do
        request = described_class.new(method: :get, uri: 'uri', headers: {'foo' => 'bar'})
        expect(request['foo']).to eql('bar')
        expect(request['other key']).to be_nil
      end

      it 'has an empty body by default' do
        expect(described_class.new(method: :get, uri: 'uri').body).to be_empty
      end

      it 'can merge attributes' do
        request = described_class.new(method: :get, uri: 'uri')
        new_request = request.merge(method: :post, body: 'body')
        expect(new_request).to be_post
        expect(new_request.uri).to eq 'uri'
        expect(new_request.body).to eq 'body'
      end

      it 'can loop over all headers' do
        request = described_class.new(method: :get, uri: 'uri', body: {}, headers: {'foo' => 'bar'})
        expect { |b|
          request.each_header(&b)
        }.to yield_successive_args(%w(foo bar))
      end
    end
  end
end
