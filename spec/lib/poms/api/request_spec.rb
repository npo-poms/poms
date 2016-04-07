require 'spec_helper'
require 'pry'

RSpec.describe Poms::Api::Request do
  let(:subject) do
    described_class.new(
      Addressable::URI.parse('https://rs.poms.omroep.nl/v1/api/media/redirects/'),
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
      allow(Poms::Api::Auth).to receive(:encode).and_return('encoded-string')
      request = a_request(
        :get,
        'https://rs.poms.omroep.nl/v1/api/media/redirects/'
      ).with(
        headers: {
          'Origin' => 'http://zapp.nl',
          'X-NPO-Date' => Time.now.rfc822,
          'Authorization' => 'NPO key:encoded-string',
          'accept' => 'application/json'
        }
      )
      subject.call
      expect(request).to have_been_requested
    end
  end
end
