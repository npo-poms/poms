require 'spec_helper'

describe Poms::Views do
  describe '#get' do
    let(:response) { File.read 'spec/fixtures/poms_broadcast.json' }

    it 'returns a metadata object' do
      stub_request(:any, 'http://docs.poms.omroep.nl/media/KRO_1614405')
        .to_return(body: response)
      expect(subject.get('KRO_1614405')).to eq(JSON.parse response)
    end
  end

  describe '#by_group' do
    it 'returns the correct group url' do
      expect(subject.by_group('POMS_S_NPO_823012')).to eq('http://docs.poms.omroep.nl/media/_design/media/_view/by-group?include_docs=true&key=%22POMS_S_NPO_823012%22&reduce=false')
    end
  end

  describe '#descendants_by_type' do
    it 'builds a url' do
      expect(subject.descendants_by_type('POMS_S_NPO_823012'))
        .to eq(
          'http://docs.poms.omroep.nl/media/_design/media/_view/by-ancestor-and-type?include_docs=true&key=%5B%22POMS_S_NPO_823012%22%2C+%22BROADCAST%22%5D&reduce=false'
        )
    end

    it 'can switch to not include docs' do
      expect(
        subject.descendants_by_type('POMS_S_NPO_823012',
                                    'BROADCAST',
                                    include_docs: false))
        .to eq(
          'http://docs.poms.omroep.nl/media/_design/media/_view/by-ancestor-and-type?include_docs=false&key=%5B%22POMS_S_NPO_823012%22%2C+%22BROADCAST%22%5D&reduce=false'
        )
    end
  end
end
