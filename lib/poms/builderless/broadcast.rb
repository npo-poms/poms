require 'poms/fields'

module Poms
  module Builderless
    # A single broadcast fetched from Poms
    class Broadcast
      def initialize(hash)
        @hash = hash
      end

      def title
        Fields.title(@hash)
      end

      def mid
        @hash['mid']
      end

      def schedule_events
        @hash['scheduleEvents'].map do |event|
          Event.new(event)
        end
      end
    end

    class Event
      def initialize(hash)
        @hash = hash
      end

      def starts_at
        @hash['start']
      end
    end
  end
end
