require 'spec_helper'

describe Poms::Timestamp do
  it 'converts Poms timestamps to DateTime' do
    expect(Poms::Timestamp.convert(1453217700000))
      .to eq(Time.parse '2016-01-19 16:35:00 +0100')
  end
end
