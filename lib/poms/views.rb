require 'poms/connect'

# Constructs urls for Poms
module Poms
  module Views
    include Poms::Connect
    extend self

    def get(mid)
      uri = "#{base_url}/media/#{mid}"
      get_json(uri)
    end

    def by_group(mid)
      args = {
        key: "\"#{mid}\"",
        reduce: false,
        include_docs: true
      }
      construct_view_url('by-group', args)
    end

    def broadcasts_by_channel_and_start(channel, start_time = Time.now,
                                        end_time = 1.day.ago, limit = 1,
                                        descending = true)
      args = {
        startkey: "[\"#{channel}\", #{to_poms_timestamp(start_time)}]",
        endkey: "[\"#{channel}\", #{to_poms_timestamp(end_time)}]",
        limit: limit,
        descending: descending,
        reduce: false,
        include_docs: true
      }
      construct_view_url('broadcasts-by-channel-and-start', args)
    end

    private

    def base_url
      'http://docs.poms.omroep.nl'
    end

    def view_path
      '/media/_design/media/_view/'
    end

    def construct_view_url(view, args)
      "#{base_url}#{view_path}#{view}?#{args.to_query}"
    end

    def to_poms_timestamp(timestamp)
      timestamp.to_i * 1000
    end
  end
end
