require 'spec_helper'

describe Poms::URIs do
  describe 'media' do
    it 'returns the correct uri for a single resource' do
      uri = Poms::URIs::Media.single('the-mid')
      expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid')
    end

    it 'returns the correct uri for multiple resources' do
      uri = Poms::URIs::Media.multiple
      expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/multiple')
    end
  end
end
