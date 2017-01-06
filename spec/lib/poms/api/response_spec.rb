require 'spec_helper'
require 'poms/api/response'

module Poms
  module Api
    RSpec.describe Response do
      subject { described_class.new('200', nil, nil) }

      it 'converts code to integer' do
        expect(subject.code).to be(200)
      end

      it 'converts body to string' do
        expect(subject.body).to eql('')
      end

      it 'converts headers to hash' do
        expect(subject.headers).to eql({})
      end

      it 'considers two respones with equal properties equal' do
        expect(subject).to eql(described_class.new('200', nil, nil))
      end
    end
  end
end
