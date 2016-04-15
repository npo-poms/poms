require 'spec_helper'

RSpec.describe Poms do
  it 'gives a meaningful error message when used without configuration' do
    expect { Poms.fetch("MID") }.to raise_error(Poms::Errors::AuthenticationError)
  end
end
