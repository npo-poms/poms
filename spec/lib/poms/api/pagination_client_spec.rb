require 'spec_helper'
require 'poms/api/pagination_client'
require 'poms/api/uris'
require 'poms/api/search'
require 'poms/configuration'

module Poms
  module Api
    RSpec.describe PaginationClient do
      let(:config) { Configuration.new }

      describe '.get' do
        it 'returns all members in one Array' do
          result = described_class.get(
            Api::Uris::Media.members(config.base_uri, 'POMS_S_NTR_2448585'),
            config
          )
          expect(result.count).to eq(16)
        end
      end

      describe '.post' do
        it 'returns all members in one Array' do
          search_params = { starts_at: DateTime.new(2014, 12, 1) }
          result = described_class.post(
            Api::Uris::Media.members(config.base_uri, 'POMS_S_NTR_2448585'),
            Api::Search.build(search_params),
            config
          )
          expect(result.count).to eq(11)
        end
      end
    end
  end
end
