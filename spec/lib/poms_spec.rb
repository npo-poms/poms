require 'spec_helper'
require 'poms'

RSpec.describe Poms do
  before do
    stub_const('ENV', {})
    described_class.reset_config
  end

  it 'gives a meaningful error message when used without credentials' do
    expect {
      described_class.fetch('MID')
    }.to raise_error(Poms::Errors::AuthenticationError)
  end

  it 'gives a meaningful error message when explicitly configured without a base URI' do
    described_class.configure do |config|
      config.base_uri = nil
    end
    expect {
      described_class.fetch('MID')
    }.to raise_error(Poms::Errors::MissingConfigurationError)
  end

  it 'falls back to a default base URI' do
    described_class.configure do |config|
      config.key = 'x'
      config.origin = 'x'
      config.secret = 'x'
    end
    expect {
      described_class.fetch('MID')
    }.not_to raise_error
  end
end
