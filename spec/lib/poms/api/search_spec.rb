require 'spec_helper'
require 'poms/api/search'

module Poms
  module Api
    describe Search do
      let(:now) { Time.now }
      let(:next_week) { 1.week.from_now }

      describe '.build' do
        it 'can handle and empty hash' do
          expect(described_class.build({})).to eq({})
        end

        it 'returns the correct hash for a start date' do
          expect(described_class.build(starts_at: now)).to eql(
            'searches' => {
              'sortDates' => {
                'begin' => Timestamp.to_unix_ms(now)
              }
            }
          )
        end

        it 'returns the correct hash for an end date' do
          expect(described_class.build(ends_at: next_week)).to eql(
            'searches' => {
              'sortDates' => {
                'end' => Timestamp.to_unix_ms(next_week)
              }
            }
          )
        end

        it 'returns a correct hash for a start and end date' do
          expect(described_class.build(starts_at: now, ends_at: next_week))
            .to eql(
              'searches' => {
                'sortDates' => {
                  'begin' => Timestamp.to_unix_ms(now),
                  'end' => Timestamp.to_unix_ms(next_week)
                }
              }
            )
        end

        it 'returns the correct facet for a given type' do
          expect(described_class.build(type: 'BROADCAST')).to eql(
            'searches' => {
              'types' => 'BROADCAST'
            }
          )
        end

        describe 'with a multitude of options' do
          subject do
            described_class.build(
              starts_at: now,
              ends_at: next_week,
              type: 'BROADCAST'
            )
          end

          let(:result) do
            {
              'searches' => {
                'sortDates' => {
                  'begin' => Timestamp.to_unix_ms(now),
                  'end' => Timestamp.to_unix_ms(next_week)
                },
                'types' => 'BROADCAST'
              }
            }
          end

          it 'works correctly with a multitude of options' do
            expect(subject).to eql(result)
          end
        end
      end
    end
  end
end
