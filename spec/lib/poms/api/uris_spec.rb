require 'spec_helper'
require 'poms/api/uris'

module Poms
  module Api
    module URIs
      RSpec.describe Media do
        let(:base_uri) { Addressable::URI.parse('https://rs.poms.omroep.nl') }

        it 'returns the correct uri for a single resource' do
          uri = described_class.single(base_uri, 'the-mid')
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid')
        end

        it 'returns the correct uri for multiple resources' do
          uri = described_class.multiple(base_uri)
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/multiple')
        end

        it 'returns the correct uri for descendants' do
          uri = described_class.descendants(base_uri, 'the-mid')
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid/descendants')
        end

        it 'returns the correct uri for members' do
          uri = described_class.members(base_uri, 'the-mid')
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid/members')
        end
      end

      RSpec.describe Schedule do
        let(:base_uri) { Addressable::URI.parse('https://rs.poms.omroep.nl') }

        it 'returns the correct uri for channel' do
          uri = described_class.channel(base_uri, 'OPVO', {})
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/schedule/channel/OPVO?')
        end

        it 'sets default params when none are provided' do
          allow(described_class)
            .to receive(:default_channel_params)
            .and_return(
              max: 1,
              sort: 'desc',
              start: Time.new(2016, 3, 31, 12, 0, 0).iso8601,
              stop: Time.new(2016, 3, 30, 12, 0, 0).iso8601
            )
          uri = described_class.channel(base_uri, 'OPVO')
          expect(uri.to_s).to eql(
            'https://rs.poms.omroep.nl/v1/api/schedule/channel/OPVO?' \
              'max=1' \
              '&sort=desc' \
              '&start=2016-03-31T12%3A00%3A00%2B02%3A00' \
              '&stop=2016-03-30T12%3A00%3A00%2B02%3A00'
          )
        end
      end
    end
  end
end
