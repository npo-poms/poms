require 'spec_helper'
require 'poms'

RSpec.describe Poms do
  before do
    described_class.reset_config
  end

  it 'gives a meaningful error message when used without credentials' do
    described_class.configure do |config|
      config.base_uri = Addressable::URI.parse('http://foo')
    end
    expect {
      described_class.fetch('MID')
    }.to raise_error(Poms::Errors::AuthenticationError)
  end

  it 'gives a meaningful error message when used without a base URI' do
    expect {
      described_class.fetch('MID')
    }.to raise_error(Poms::Errors::MissingConfigurationError)
  end
end
