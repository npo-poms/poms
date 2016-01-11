require 'spec_helper'

describe Poms::MergedSeries do
  let(:url) { described_class::API_URL }

  it 'turns the json into a hash' do
    mids = subject.serie_mids
    expect(mids.keys).to include('POMS_S_EO_097367')
    expect(mids.values).to include('VPWON_1257896')
  end

  it 'throws an error on a network error' do
    FakeWeb.register_uri(:get, url, body:
    '', status: 500)
    expect { subject.serie_mids }.to raise_error(Poms::PomsError)
  end

  it 'throws an error on invalid json' do
    FakeWeb.register_uri(:get, url, body:
    'Test')
    expect { subject.serie_mids }.to raise_error(Poms::PomsError)
  end

  it 'throws an error on timeout' do
    allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)
    expect { subject.serie_mids }.to raise_error(Poms::PomsError)
  end
end
