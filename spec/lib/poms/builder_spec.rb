require 'spec_helper'

describe Poms::Builder do
  let(:poms_broadcast) { Fabricate(:poms_broadcast) }

  it 'correctly sets the class of a POMS broadcast hash' do
    expect(poms_broadcast.class).to eq(Poms::Broadcast)
  end

  it 'correctly renames and parses the broadcast\'s schedule_events' do
    expect(poms_broadcast.schedule_events.length).to eq(1)
  end

  it 'correctly converts start times to Time-object' do
    expect(poms_broadcast.schedule_events.first.start).to eq(Time.parse '2013-05-28 18:08:55 +0200')
  end
end
