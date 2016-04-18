require 'spec_helper'

RSpec.describe Poms do
  it 'gives a meaningful error message when used without configuration' do
    expect { described_class.fetch("MID") }
      .to raise_error(Poms::Errors::AuthenticationError)
  end

  describe '.members' do
    let(:config) { double('config') }

    before do
      allow(described_class).to receive(:assert_credentials)
      allow(described_class).to receive(:config).and_return(config)
    end

    it 'fetches members of a mid' do
      request = double('request', execute: double('body', body:
        { key: 'value' }.to_json))
      expect(Poms::Api::Media).to receive(:members)
        .with('POMS_S_NTR_601648', config).and_return(request)
      expect(described_class.members('POMS_S_NTR_601648'))
        .to eq('key' => 'value')
    end
  end
end
