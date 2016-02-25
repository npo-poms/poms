require 'poms/connect'

module Poms
  # Views constructs the urls that can be used to access specific views in POMS.
  module Views
    include Poms::Connect
    extend self

    BASE_URL = 'http://docs.poms.omroep.nl'.freeze
    DEFAULT_OPTIONS = { reduce: false, include_docs: true }.freeze
    VIEW_PATH = '/media/_design/media/_view/'.freeze

    def get(mid)
      uri = "#{BASE_URL}/media/#{mid}"
      get_json(uri)
    end

    def by_group(mid)
      args = {
        key: "\"#{mid}\""
      }.merge(DEFAULT_OPTIONS)
      construct_view_url('by-group', args)
    end

    # Constructs a url using the by-ancestor-and-type view of Poms.
    def descendants_by_type(mid, type = 'BROADCAST', options = {})
      options = DEFAULT_OPTIONS.merge(options)
      args = {
        key: "[\"#{mid}\", \"#{type}\"]"
      }.merge(options)
      construct_view_url('by-ancestor-and-type', args)
    end

    def broadcasts_by_channel_and_start(channel, start_time = Time.now,
                                        end_time = 1.day.ago, limit = 1,
                                        descending = true)
      args = {
        startkey: "[\"#{channel}\", #{to_poms_timestamp(start_time)}]",
        endkey: "[\"#{channel}\", #{to_poms_timestamp(end_time)}]",
        limit: limit,
        descending: descending
      }.merge(DEFAULT_OPTIONS)
      construct_view_url('broadcasts-by-channel-and-start', args)
    end

    private

    def construct_view_url(view, args)
      "#{BASE_URL}#{VIEW_PATH}#{view}?#{args.to_query}"
    end

    def to_poms_timestamp(timestamp)
      timestamp.to_i * 1000
    end
  end
end
