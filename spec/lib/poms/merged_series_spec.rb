require 'spec_helper'

describe Poms::MergedSeries do
  it 'turns the json into a hash' do
    mids = subject.serie_mids(Poms::MergedSeries::API_URL)
    expect(mids.keys).to include('POMS_S_EO_097367')
    expect(mids.values).to include('VPWON_1257896')
  end

  it 'is enumerable' do
    expect(subject.map { |_, new_mid| new_mid })
      .to include('VPWON_1257896')
  end
end
