require 'timecop'
require 'spec_helper'

describe Poms do
  describe '#fetch' do
    let(:response)  { File.read 'spec/fixtures/poms_broadcast.json' }

    before do
      stub_request(:get, 'http://docs.poms.omroep.nl/media/KRO_1614405')
        .to_return(body: response)
    end

    it 'fetches a broadcast' do
      expect(Poms.fetch_raw_json('KRO_1614405')).to eq(JSON.parse response)
    end

    it 'fetches a broadcast and parses it correctly' do
      expect(Poms::Builder).to receive(:process_hash).with(JSON.parse response)
      Poms.fetch('KRO_1614405')
    end

    it 'fetches a group' do
      response = File.read 'spec/fixtures/poms_broadcast.json'
      url = 'http://docs.poms.omroep.nl/media/_design/media/_view/by-group?include_docs=true&key=%22POMS_S_NPO_823012%22&reduce=false'
      stub_request(:get, url).to_return(body: response)
      expect(Poms.fetch_group('POMS_S_NPO_823012')).to eq(JSON.parse response)
    end

    it 'returns nil when a broadcast does not exits' do
      stub_request(:get, 'http://docs.poms.omroep.nl/media/BLA')
        .to_return(status: [404, 'Not Found'])
      expect(Poms.fetch('BLA')).to eq(nil)
    end
  end

  describe '#fetch_playlist_clips' do
    it 'creates an array of clips' do
      expect(Poms.fetch_playlist_clips('POMS_S_NPO_818759').size).to eq(23)
    end
  end

  describe '#fetch_broadcasts_for_serie' do
    it 'returns nil when a broadcast does not exist' do
      stub_request(:get, 'http://docs.poms.omroep.nl/media/_design/media/_view/by-ancestor-and-type?reduce=false&key=[%22BLA%22,%22BROADCAST%22]&include_docs=true')
        .to_return(status: [404, 'Not Found'])
      expect(Poms.fetch_broadcasts_for_serie('BLA')).to eq([])
    end
  end

  describe '#upcoming_broadcasts' do
    let(:response)    { File.read 'spec/fixtures/poms_zapp.json' }
    let(:start_time)  { Time.parse '2013-05-28 17:32:10 +0200' }
    let(:end_time)    { Time.parse '2013-06-11 17:32:50 +0200' }

    before do
      path = 'http://docs.poms.omroep.nl/media/_design/media/_view/broadcasts-by-broadcaster-and-start?startkey=[%22Zapp%22,1369755130000]&endkey=[%22Zapp%22,1370964770000]&reduce=false&include_docs=true'
      stub_request(:get, path).to_return(body: response)
    end

    it 'fetches all broadcast by zapp and parses it correctly' do
      expect(Poms::Builder).to receive(:process_hash).exactly(136).times
      Poms.upcoming_broadcasts('zapp', start_time, end_time)
    end
  end

  describe 'fetch broadcasts' do
    let(:response) do
      File.read 'spec/fixtures/poms_single_broadcast_by_channel.json'
    end

    before do
      Timecop.freeze(DateTime.strptime('1410969127', '%s'))
    end

    after do
      Timecop.return
    end

    describe '#fetch_current_broadcast' do
      before do
        path = 'http://docs.poms.omroep.nl/media/_design/media/_view/broadcasts-by-channel-and-start?startkey=[%22NED3%22,1410969127000]&endkey=[%22NED3%22,1410882727000]&reduce=false&include_docs=true&descending=true&limit=1'
        stub_request(:get, path).to_return(body: response)
      end

      it 'fetches the current broadcast' do
        expect(Poms::Builder).to receive(:process_hash).exactly(0).times
        Poms.fetch_current_broadcast('NED3')
      end
    end

    describe '#fetch_current_broadcast_and_key' do
      before do
        path = 'http://docs.poms.omroep.nl/media/_design/media/_view/broadcasts-by-channel-and-start?startkey=[%22NED3%22,1410969127000]&endkey=[%22NED3%22,1410882727000]&reduce=false&include_docs=true&descending=true&limit=1'
        stub_request(:get, path).to_return(body: response)
      end

      it 'fetches the current broadcast' do
        expect(Poms::Builder).to receive(:process_hash).exactly(1).times
        Poms.fetch_current_broadcast_and_key('NED3')
      end

      it 'returns the key' do
        expect(Poms.fetch_current_broadcast_and_key('NED3')[:key])
          .to eq(['NED3', 1_410_966_671_000])
      end
    end

    describe '#fetch_next_broadcast' do
      before do
        path = 'http://docs.poms.omroep.nl/media/_design/media/_view/broadcasts-by-channel-and-start?startkey=[%22NED3%22,1410969127000]&endkey=[%22NED3%22,1411055527000]&reduce=false&include_docs=true&limit=1'
        stub_request(:get, path).to_return(body: response)
      end

      it 'fetches the next broadcast' do
        expect(Poms::Builder).to receive(:process_hash).exactly(1).times
        Poms.fetch_next_broadcast('NED3')
      end
    end

    describe '#fetch_next_broadcast_and_key' do
      before do
        path = 'http://docs.poms.omroep.nl/media/_design/media/_view/broadcasts-by-channel-and-start?startkey=[%22NED3%22,1410969127000]&endkey=[%22NED3%22,1411055527000]&reduce=false&include_docs=true&descending=true&limit=1'
        stub_request(:get, path).to_return(body: response)
      end

      it 'fetches the current broadcast' do
        expect(Poms::Builder).to receive(:process_hash).exactly(1).times
        Poms.fetch_next_broadcast_and_key('NED3')
      end

      it 'returns the key' do
        expect(Poms.fetch_next_broadcast_and_key('NED3')[:key])
          .to eq(['NED3', 1_410_969_900_000])
      end
    end
  end
end
