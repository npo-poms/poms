require 'spec_helper'

module Poms
  module Api
    RSpec.describe Request do
      it 'requires a valid HTTP method' do
        expect {
          described_class.new('bla', 'uri')
        }.to raise_error(ArgumentError, 'method should be :get or :post')

        expect {
          described_class.new('get', 'uri')
        }.not_to raise_error
      end

      it 'indicates whether it is a get or post request' do
        expect(described_class.new(:get, 'uri')).to be_get
        expect(described_class.new(:post, 'uri')).to be_post
      end

      it 'can read header values' do
        request = described_class.new(:get, 'uri', nil, 'foo' => 'bar')
        expect(request['foo']).to eql('bar')
        expect(request['other key']).to be_nil
      end

      it 'has an empty body by default' do
        expect(described_class.new(:get, 'uri').body).to be_empty
      end

      it 'can write headers' do
        request = described_class.new(:get, 'uri')
        expect {
          request['foo'] = 'bar'
        }.to change { request['foo'] }.from(nil).to('bar')
      end

      it 'can loop over all headers' do
        request = described_class.new(:get, 'uri', {}, 'foo' => 'bar')
        expect { |b|
          request.each_header(&b)
        }.to yield_successive_args(%w(foo bar))
      end
    end
  end
end
