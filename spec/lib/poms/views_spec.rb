require 'spec_helper'

describe Poms::Views do
  describe '#get' do
    let(:response) { File.read 'spec/fixtures/poms_broadcast.json' }

    it 'returns a metadata object' do
      FakeWeb.register_uri(:get, 'http://docs.poms.omroep.nl/media/KRO_1614405',
                           body: response)
      expect(subject.get('KRO_1614405')).to eq(JSON.parse response)
    end
  end

  describe '#by_group' do
    it 'returns the correct group url' do
      expect(subject.by_group('POMS_S_NPO_823012')).to eq('http://docs.poms.omroep.nl/media/_design/media/_view/by-group?include_docs=true&key=%22POMS_S_NPO_823012%22&reduce=false')
    end
  end
end
