require 'spec_helper'
require 'pry'

RSpec.describe Poms::Api::Request do
  let(:test_url) { 'https://rs.poms.omroep.nl/v1/api/media' }
  let(:subject) do
    uri = Addressable::URI.parse(test_url)
    credentials = OpenStruct.new(key: 'key', secret: 'secret', origin: 'http://zapp.nl')
    described_class.new(uri, credentials)
  end

  describe '.call' do
    it 'makes the request' do
      stub = stub_request(:get, test_url)
      subject.call
      expect(stub).to have_been_requested
    end

    it 'sets the headers' do
      allow(Poms::Api::Auth).to receive(:encode).and_return('encoded-string')
      stub = stub_request(:get, test_url).with(
        headers: {
          'Origin' => 'http://zapp.nl',
          'X-NPO-Date' => Time.now.rfc822,
          'Authorization' => 'NPO key:encoded-string'
        }
      )
      subject.call
      expect(stub).to have_been_requested
    end
  end

  describe '.post' do
    it 'makes a post request' do
      stub = stub_request(:post, test_url)
      subject.post
      expect(stub).to have_been_requested
    end

    it 'sets the post body' do
      stub = stub_request(:post, test_url).with(body: { foo: 'bar' }.to_json)
      subject.post(foo: 'bar')
      expect(stub).to have_been_requested
    end
  end
end
