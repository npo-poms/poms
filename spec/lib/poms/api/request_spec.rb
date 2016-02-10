require 'poms/api/request'
require 'spec_helper'

RSpec.describe Poms::Api::Request do
  let(:subject) do
    described_class.new(
      'https://rs.poms.omroep.nl/v1/api/media/redirects/',
      'key',
      'secret',
      'http://zapp.nl')
  end

  describe '#call' do
    it 'makes the request' do
      stub = stub_request(:get, 'https://rs.poms.omroep.nl/v1/api/media/redirects/')
      subject.call
      expect(stub).to have_been_requested
    end

    it 'sets the headers' do
      headers = { 'Test' => 'Header' }
      stub = stub_request(:get,
                          'https://rs.poms.omroep.nl/v1/api/media/redirects/')
             .with(headers: headers)
      allow(subject).to receive(:headers).and_return(headers)
      subject.call
      expect(stub).to have_been_requested
    end
  end
end
