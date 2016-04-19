require 'spec_helper'
require 'poms'

RSpec.describe Poms do
  it 'gives a meaningful error message when used without configuration' do
    expect { described_class.fetch('MID') }
      .to raise_error(Poms::Errors::AuthenticationError)
  end
end
