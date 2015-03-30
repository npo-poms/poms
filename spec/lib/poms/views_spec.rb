require 'spec_helper'

describe Poms::Views do
  it 'returns the correct group url' do
    expect(subject.by_group('POMS_S_NPO_823012')).to eq('http://docs.poms.omroep.nl/media/_design/media/_view/by-group?include_docs=true&key=%22POMS_S_NPO_823012%22&reduce=false')
  end
end
