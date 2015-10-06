require 'spec_helper'

describe Poms do

  describe '#fetch_current_broadcast' do
    let(:current_broadcast) { Poms.fetch_current_broadcast('NED3') }

    it 'has a title' do
      expect(current_broadcast.title).to be_present
    end

    it 'has a mid' do
      expect(current_broadcast.mid).to be_present
    end

    it 'has scheduled events with last with starts_at' do
      expect(current_broadcast.schedule_events.last.starts_at).to be_present
    end
  end

  describe '#fetch_current_broadcast' do
    let(:current_broadcast) { Poms.fetch_current_broadcast_and_key('NED3') }

    it 'has a key' do
      expect(current_broadcast[:key]).to be_present
    end

    it 'has a broadcast with a mid' do
      expect(current_broadcast[:broadcast].mid).to be_present
    end
  end
end
