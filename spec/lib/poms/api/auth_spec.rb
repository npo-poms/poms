require 'poms/api/auth'
require 'poms/configuration'
require 'spec_helper'

module Poms
  module Api
    RSpec.describe Auth do
      let(:timestamp) { Date.parse('2015-01-01') }

      describe '.message' do
        it 'creates a message' do
          message = described_class.message(
            Addressable::URI.parse('/v1/api/media/redirects/'),
            'http://zapp.nl',
            timestamp.rfc822
          )
          expect(message).to eq(
            'origin:http://zapp.nl,x-npo-date:Thu, 1 Jan 2015 00:00:00 '\
            '+0000,uri:/v1/api/media/redirects/')
        end

        it 'sorts the params' do
          message = described_class.message(
            Addressable::URI.parse('/v1/api/media/redirects/?b=1&a=2'),
            'http://zapp.nl',
            timestamp.rfc822
          )
          expect(message).to eq(
            'origin:http://zapp.nl,x-npo-date:Thu, 1 Jan 2015 00:00:00 '\
            '+0000,uri:/v1/api/media/redirects/,a:2,b:1')
        end
      end

      describe '.encoded_message' do
        it 'returns the encoded message' do
          uri = Addressable::URI.parse('/v1/api/media/')
          credentials = Configuration.new
          expect(described_class.encoded_message(uri, credentials, timestamp))
            .to eq('DL0JOB6ahzRV/8qGduGa9D2dHwn1iArUqb46NsQzTbk=')
        end
      end
    end
  end
end
