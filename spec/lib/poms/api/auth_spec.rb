require 'poms/api/auth'
require 'poms/configuration'
require 'spec_helper'

module Poms
  module Api
    RSpec.describe Auth do
      describe '.encoded_message' do
        it 'returns the encoded message' do
          uri = Addressable::URI.parse('/v1/api/media/')
          timestamp = Date.parse('2015-01-01')
          credentials = Configuration.new

          expect(described_class.encoded_message(uri, credentials, timestamp))
            .to eq('DL0JOB6ahzRV/8qGduGa9D2dHwn1iArUqb46NsQzTbk=')
        end
      end
    end
  end
end
