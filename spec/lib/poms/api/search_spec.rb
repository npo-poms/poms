require 'spec_helper'

module Poms
  module Api
    describe Search do
      let(:now) { Time.now }
      let(:next_week) { 1.week.from_now }

      describe 'sortDate' do
        it 'returns the correct hash for a start date' do
          subject = described_class.build(start_time: now)
          expect(subject).to eql(
            'searches' => { 'sortDates' => { 'begin' => now.to_i * 1000 } }
          )
        end

        it 'returns the correct hash for an end date' do
          subject = described_class.build(end_time: next_week)
          expect(subject).to eql(
            'searches' => { 'sortDates' => { 'end' => next_week.to_i * 1000 } }
          )
        end

        it 'returns a correct hash for a start and end date' do
          subject = described_class.build(start_time: now, end_time: next_week)
          expect(subject).to eql(
            'searches' => {
              'sortDates' => {
                'begin' => now.to_i * 1000,
                'end' => next_week.to_i * 1000
              }
            }
          )
        end
      end

      describe 'type' do
        subject { described_class.build(type: 'BROADCAST') }
        it 'returns the correct facet for a given type' do
          expect(subject).to eql(
            'facets' => {
              'subsearch' => {
                'types' => 'BROADCAST'
              }
            }
          )
        end
      end

      describe 'all' do
        it 'works correctly with a multitude of options' do
          subject = described_class.build(
            start_time: now,
            end_time: next_week,
            type: 'BROADCAST'
          )
          expect(subject).to eql(
            'searches' => {
              'sortDates' => {
                'begin' => now.to_i * 1000,
                'end' => next_week.to_i * 1000
              }
            },
            'facets' => {
              'subsearch' => {
                'types' => 'BROADCAST'
              }
            }
          )
        end
      end
    end
  end
end
