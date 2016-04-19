require 'spec_helper'
require 'poms/api/uris'

module Poms
  module Api
    module URIs
      RSpec.describe Media do
        let(:base_uri) { Addressable::URI.parse('https://rs.poms.omroep.nl') }

        it 'returns the correct uri for a single resource' do
          uri = described_class.single('the-mid', base_uri)
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid')
        end

        it 'returns the correct uri for multiple resources' do
          uri = described_class.multiple(base_uri)
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/multiple')
        end

        it 'returns the correct uri for descendants' do
          uri = described_class.descendants('the-mid', base_uri)
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid/descendants')
        end

        it 'returns the correct uri for members' do
          uri = described_class.members('the-mid', base_uri)
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid/members')
        end
      end
    end
  end
end
