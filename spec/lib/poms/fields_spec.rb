require 'spec_helper'
require 'poms/fields'

describe Poms::Fields do
  let(:poms_data) { JSON.parse File.read('spec/fixtures/poms_broadcast.json') }

  describe '#title' do
    it 'returns the first MAIN title' do
      expect(described_class.title(poms_data)).to eq('VRijland')
    end

    it 'returns nil if no title can be found' do
      expect(described_class.title(poms_data, 'NONEXISTANTTYPE')).to be_nil
    end
  end

  describe '#description' do
    it 'returns the first MAIN description' do
      expect(described_class.description(poms_data)).to eq("Li biedt Barry \
een baantje aan bij de uitdragerij en vraagt zich meteen af of dat wel zo slim \
was. Timon en Joep zien de criminele organisatie de Rijland Angels. Timon wil \
naar hun loods, maar is dat wel een goed idee?")
    end

    it 'returns nil if no description can be found' do
      expect(described_class.description(poms_data, 'NONEXISTANTTYPE'))
        .to be_nil
    end
  end

  describe '#image_id' do
    it 'returns the id of the image' do
      expect(described_class.image_id(poms_data['images'].first))
        .to eq('184169')
    end

    it 'returns nil if there is no image' do
      expect(described_class.image_id({})).to be_nil
    end
  end

  describe '#first_image_id' do
    it 'returns the id of the first image' do
      expect(described_class.first_image_id(poms_data)).to eq('184169')
    end

    it 'returns nil if there is no image' do
      expect(described_class.first_image_id({})).to be_nil
    end
  end

  describe '#rev' do
    it 'returns the current Poms revision' do
      expect(described_class.rev(poms_data)).to eq(60)
    end

    it 'returns 0 if it cannot be found' do
      expect(described_class.rev({})).to eq(0)
    end
  end

  describe '#odi_streams' do
    it 'returns an array of stream types' do
      expect(described_class.odi_streams(poms_data)).to match_array(
        %w(adaptive h264_sb h264_bb h264_std wvc1_std wmv_sb wmv_bb))
    end

    it 'returns an empty array of no stream types are found' do
      expect(described_class.odi_streams({})).to eq([])
    end
  end

  describe '#available_until' do
    it 'returns the enddate of the INTERNETVOD prediction' do
      expect(described_class.available_until(poms_data))
        .to eq('Sat, 27 Jun 2015 07:12:48 +0200')
    end

    it 'returns nil if the INTERNETVOD has no publishStop' do
      expect(
        described_class.available_until(
          'predictions' => [
            { 'state' => 'REALIZED', 'platform' => 'INTERNETVOD' }]))
        .to be_nil
    end
  end

  describe '#position' do
    it 'returns the position' do
      clip = JSON.parse File.read('spec/fixtures/poms_clip.json')
      expect(described_class.position(clip)).to eq(1)
    end

    it 'returns nil if it not a member of anything' do
      expect(described_class.position(poms_data)).to be_nil
    end
  end
end
