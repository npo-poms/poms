require 'spec_helper'
require 'poms/configuration'

module Poms
  RSpec.describe Configuration do
    subject do
      described_class.new do |c|
        c.key = 'a'
        c.secret = 'b'
        c.origin = 'c'
        c.base_uri = 'd'
      end
    end

    before do
      stub_const('ENV', {})
    end

    it 'is built using configure method taking a block to set keys' do
      expect(subject.key).to eql('a')
      expect(subject.secret).to eql('b')
      expect(subject.origin).to eql('c')
      expect(subject.base_uri).to eql('d')
    end

    it 'does not allow changes to the configuration' do
      expect(subject).to be_frozen
    end

    it 'raises error when not all credentials are set' do
      expect {
        described_class.new do |c|
          c.base_uri = 'bla'
        end
      }.to raise_error(Poms::Errors::AuthenticationError)
    end

    it 'raises error when the base URI is explicitly set to nil' do
      expect {
        described_class.new do |c|
          c.key = 'a'
          c.secret = 'a'
          c.origin = 'a'
          c.base_uri = nil
        end
      }.to raise_error(Poms::Errors::MissingConfigurationError)
    end

    it 'uses a default base URI when not explicitly configured' do
      config = described_class.new do |c|
        c.key = 'a'
        c.secret = 'a'
        c.origin = 'a'
      end
      expect(config.base_uri.to_s).to eql('https://rs.poms.omroep.nl')
    end

    it 'reads values from ENV when not explicitly configured' do
      stub_const(
        'ENV',
        'POMS_KEY' => 'a',
        'POMS_SECRET' => 'b',
        'POMS_ORIGIN' => 'c',
        'POMS_BASE_URI' => 'd'
      )
      config = described_class.new
      expect(config.key).to eql('a')
      expect(config.secret).to eql('b')
      expect(config.origin).to eql('c')
      expect(config.base_uri.to_s).to eql('d')
    end

    describe '.credentials' do
      let(:credentials) { subject.credentials }

      it 'returns the credentials in a struct' do
        expect(credentials.key).to eql('a')
        expect(credentials.secret).to eql('b')
        expect(credentials.origin).to eql('c')
      end

      it 'does not have the base_uri' do
        expect(credentials.base_uri).not_to be_present
      end
    end
  end
end
