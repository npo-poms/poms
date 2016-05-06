require 'spec_helper'
require 'poms/api/uris/schedule'

module Poms
  module Api
    module Uris
      RSpec.describe Schedule do
        let(:base_uri) { Addressable::URI.parse('https://rs.poms.omroep.nl') }

        describe '.now' do
          it 'returns the correct uri for channel' do
            uri = described_class.now(base_uri, 'OPVO')
            expect(uri.to_s).to eql(
              'https://rs.poms.omroep.nl/v1/api/schedule/channel/OPVO/now'
            )
          end
        end

        describe '.next' do
          it 'returns the correct uri for channel' do
            uri = described_class.next(base_uri, 'OPVO')
            expect(uri.to_s).to eql(
              'https://rs.poms.omroep.nl/v1/api/schedule/channel/OPVO/next'
            )
          end
        end
      end
    end
  end
end
