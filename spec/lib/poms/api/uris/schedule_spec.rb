require 'spec_helper'
require 'poms/api/uris/schedule'

module Poms
  module Api
    module Uris
      RSpec.describe Schedule do
        let(:base_uri) { Addressable::URI.parse('https://rs.poms.omroep.nl') }

        it 'returns the correct uri for channel' do
          uri = described_class.channel(base_uri, 'OPVO', {})
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/schedule/channel/OPVO?')
        end

        it 'sets default params when none are provided' do
          Timecop.freeze(Time.new(2016, 3, 31, 12, 0, 0, '+02:00')) do
            uri = described_class.channel(base_uri, 'OPVO')
            expect(uri.to_s).to eql(
              'https://rs.poms.omroep.nl/v1/api/schedule/channel/OPVO?' \
                'max=1' \
                '&sort=desc' \
                '&start=2016-03-30T12%3A00%3A00%2B02%3A00' \
                '&stop=2016-03-31T12%3A00%3A00%2B02%3A00'
            )
          end
        end
      end
    end
  end
end
