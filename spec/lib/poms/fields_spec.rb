require 'spec_helper'

describe Poms::Fields do
  subject { Poms::Fields }
  let(:poms_data) { JSON.parse File.read('spec/fixtures/poms_broadcast.json') }

  describe '#title' do
    it 'returns the first MAIN title' do
      expect(subject.title(poms_data)).to eq('VRijland')
    end
  end

  describe '#description' do
    it 'returns the first MAIN description' do
      expect(subject.description(poms_data)).to eq("Li biedt Barry een baantje \
aan bij de uitdragerij en vraagt zich meteen af of dat wel zo slim was. Timon \
en Joep zien de criminele organisatie de Rijland Angels. Timon wil naar hun \
loods, maar is dat wel een goed idee?")
    end
  end

  describe '#first_image_id' do
    it 'returns the if of the first image' do
      expect(subject.first_image_id(poms_data)).to eq('184169')
    end
  end

  describe '#rev' do
    it 'returns the current Poms revision' do
      expect(subject.rev(poms_data)).to eq(60)
    end
  end

  describe '#odi_streams' do
    it 'returns an array of stream types' do
      expect(subject.odi_streams(poms_data)).to match_array(
        %w(adaptive h264_sb h264_bb h264_std wvc1_std wmv_sb wmv_bb))
    end
  end

  describe '#available_until' do
    it 'returns the enddate of the INTERNETVOD prediction' do
      expect(subject.available_until(poms_data))
        .to eq('Sat, 27 Jun 2015 07:12:48 +0200')
    end
  end
end
