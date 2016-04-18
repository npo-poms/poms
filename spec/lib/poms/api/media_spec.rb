require 'spec_helper'

module Poms
  module Api
    describe Media do
      let(:dummy_credentials) { {} }

      describe '.from_mid' do
        subject { described_class.from_mid('the-mid', dummy_credentials) }
        it 'builds an executable get request' do
          expect(subject).to respond_to(:execute)
        end

        it 'builds a request targeting the correct endpoint' do
          expect(subject.uri.to_s).to eq('https://rs.poms.omroep.nl/v1/api/media/the-mid')
        end
      end

      describe '.multiple' do
        subject { described_class.multiple(['mid1', 'mid2'], dummy_credentials) }

        it 'builds an executable request' do
          expect(subject).to respond_to(:execute)
        end

        it 'builds a request to the correct endpoint' do
          expect(subject.uri.to_s).to eq('https://rs.poms.omroep.nl/v1/api/media/multiple')
        end

        it 'will execute with the correct body' do
          expect(subject.body).to eql(['mid1', 'mid2'].to_json)
        end
      end

      describe '.descendants' do
        context 'without search parameters' do
          subject { described_class.descendants('the-mid', dummy_credentials) }

          it 'builds an executable request' do
            expect(subject).to respond_to(:execute)
          end

          it 'builds a request to the correct endpoint' do
            expect(subject.uri.to_s).to eq('https://rs.poms.omroep.nl/v1/api/media/the-mid/descendants')
          end
        end

        context 'with search params' do
          let(:search_params) { { starts_at: Time.now } }

          it 'will execute with the correct body' do
            subject = described_class.descendants(
              'the-mid',
              dummy_credentials,
              search_params
            )
            expect(subject.body).to eql(Search.build(search_params).to_json)
          end
        end
      end

      describe '.members' do
        subject { described_class.members('the-mid', {}) }

        it 'builds an executable request' do
          expect(subject).to respond_to(:execute)
        end

        it 'builds a request to the correct endpoint' do
          expect(subject.uri.to_s).to eq('https://rs.poms.omroep.nl/v1/api/media/the-mid/members')
        end
      end
    end
  end
end
