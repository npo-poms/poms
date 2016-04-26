require 'spec_helper'
require 'poms'

RSpec.describe Poms do
  before do
    described_class.reset_config
  end

  it 'requires configuration' do
    expect {
      described_class.fetch('MID')
    }.to raise_error(Poms::Errors::NotConfigured)
  end
end
