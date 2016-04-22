require 'spec_helper'
require 'poms'

RSpec.describe Poms do
  before do
    described_class.reset_config
  end

  it 'requires configuration' do
    expect {
      described_class.fetch('MID')
    }.to raise_error(Poms::Errors::NotConfigured)
  end

  describe '.merged_series' do
    let(:url) { 'https://rs.poms.omroep.nl/v1/api/media/redirects/' }

    before do
      described_class.configure
    end

    it 'turns the json into a hash' do
      mids = described_class.merged_series
      expect(mids.keys).to include('POMS_S_EO_097367')
      expect(mids.values).to include('VPWON_1257896')
    end

    it 'throws an error on a network error' do
      stub_request(:any, url).to_return(body: '{}', status: 500)
      expect { described_class.merged_series }
        .to raise_error(Poms::Errors::HttpServerError)
    end

    it 'throws an error on invalid json' do
      stub_request(:any, url).to_return(body: 'Test')
      expect { described_class.merged_series }.to raise_error(JSON::ParserError)
    end

    it 'throws an error on timeout' do
      stub_request(:any, url).to_timeout
      expect { described_class.merged_series }.to raise_error(Poms::Errors::HttpError)
    end
  end
end
