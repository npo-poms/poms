require 'poms/has_ancestors'
require 'poms/has_base_attributes'

module Poms
  # POMS wrapper for an episode of a Serie.
  class Broadcast < Poms::Builder::NestedOpenStruct
    include Poms::HasAncestors
    include Poms::HasBaseAttributes

    def initialize(hash)
      super
      process_schedule_events
    end

    def process_schedule_events
      if schedule_events
        schedule_events.select! { |e| e.channel.match Poms::VALID_CHANNELS }
      end
      self.schedule_events = schedule_events.map do |e|
        Poms::ScheduleEvent.new e.marshal_dump
      end if schedule_events
    end

    def series_mid
      serie.try :mid_ref || serie.mid
    end

    def odi_streams
      return [] if locations.nil? || locations.empty?
      odi_streams = locations.select { |l| l.program_url.match(/^odi/) }
      streams = odi_streams.map do |l|
        l.program_url.match(/^[\w+]+\:\/\/[\w\.]+\/video\/(\w+)\/\w+/)[1]
      end
      streams.uniq
    end

    def available_until
      return if predictions.blank?
      timestamp = offline_timestamp(predictions)
      return Time.at(timestamp / 1000).to_datetime if timestamp
    end

    private

    def offline_timestamp(predictions, platform = 'INTERNETVOD')
      timestamps = predictions.map do |p|
        p.publish_stop if p.platform == platform
      end.compact
      timestamps.first unless timestamps.empty?
    end
  end

  class Strand < Broadcast
  end
end
