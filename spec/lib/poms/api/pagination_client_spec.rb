require 'spec_helper'
require 'poms/api/pagination_client'
require 'poms/api/uris'
require 'poms/configuration'

module Poms
  module Api
    RSpec.describe PaginationClient do
      let(:config) { Configuration.new }

      describe '.all' do
        it 'returns all members in one Array' do
          result = described_class.all(
            Api::URIs::Media.members('POMS_S_NTR_2448585', config.base_uri),
            config
          )
          expect(result.count).to eq(16)
        end
      end
    end
  end
end
