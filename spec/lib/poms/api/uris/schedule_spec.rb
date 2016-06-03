require 'spec_helper'
require 'poms/api/uris/schedule'

module Poms
  module Api
    module Uris
      RSpec.describe Schedule do
        let(:base_uri) { Addressable::URI.parse('https://rs.poms.omroep.nl') }

        describe '.now' do
          subject { described_class.now(base_uri, 'OPVO') }

          it 'returns the correct uri path for channel' do
            expect(subject.path).to eql(
              '/v1/api/schedule/channel/OPVO'
            )
          end

          it 'returns the correct query' do
            expect(subject.query_values).to include("stop")
            expect(subject.query_values).to include(
              "max" => "1",
              "sort" => "desc"
            )
          end
        end

        describe '.next' do
          subject { described_class.next(base_uri, 'OPVO') }

          it 'returns the correct uri for channel' do
            expect(subject.path).to eql(
              '/v1/api/schedule/channel/OPVO'
            )
          end

          it 'returns the correct query' do
            expect(subject.query_values).to include("start")
            expect(subject.query_values).to include(
              "max" => "1",
              "sort" => "asc"
            )
          end
        end
      end
    end
  end
end
