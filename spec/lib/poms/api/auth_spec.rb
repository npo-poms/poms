require 'poms/api/auth'
require 'poms/configuration'
require 'spec_helper'

module Poms
  module Api
    RSpec.describe Auth do
      let(:timestamp) { Time.new(2016, 4, 19, 7, 48, 46, '+02:00') }
      let(:uri) { Addressable::URI.parse('/v1/api/media/') }
      let(:credentials) do
        double(
          'Credentials',
          origin: 'my origin',
          key: 'mykey',
          secret: 'mysecret'
        )
      end

      describe '.sign' do
        it 'signs requests' do
          headers = {}
          request = Request.get(uri, nil, headers)
          signed_request = described_class.sign(request, credentials, timestamp)

          expect(signed_request['Origin']).to eql('my origin')
          expect(signed_request['X-NPO-Date']).to eql(
            'Tue, 19 Apr 2016 07:48:46 +0200'
          )
          expect(signed_request['Authorization']).to eql(
            'NPO mykey:PfeMP5/G9NmyprlaCsxiGU2F8l85OWRbDOj+kLbvuFA='
          )
        end
      end
    end
  end
end
