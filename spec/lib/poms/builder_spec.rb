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
    expect(poms_broadcast.schedule_events.first.start)
      .to eq(Time.parse '2013-05-28 18:08:55 +0200')
  end

  describe '.pomsify_class_name' do
    it 'returns "Typeless" for nothing' do
      expect(described_class.pomsify_class_name(''))
        .to eq('Typeless')
    end

    it 'returns a supported class' do
      expect(described_class.pomsify_class_name('Broadcast'))
        .to eq('Broadcast')
    end

    it 'preprends Poms to an unsupported class' do
      expect(described_class.pomsify_class_name('Other'))
        .to eq('PomsOther')
    end

    it 'capitalizes' do
      expect(described_class.pomsify_class_name('broadcast'))
        .to eq('Broadcast')
    end
  end

  describe '.poms_class' do
    it 'gets the Poms class if it exists' do
      expect(described_class.poms_class('Broadcast'))
        .to eq(Poms::Broadcast)
    end

    it 'sets a NestedOpenStruct if it does not exist' do
      poms_other = described_class.poms_class('PomsOther')
      expect(poms_other).to eq(Poms::PomsOther)
      expect(poms_other.ancestors).to include(Poms::Builder::NestedOpenStruct)
    end
  end
end
