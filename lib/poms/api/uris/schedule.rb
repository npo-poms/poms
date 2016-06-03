require 'addressable/uri'

module Poms
  module Api
    module Uris
      # URI for the /schedule API
      module Schedule
        API_PATH = '/v1/api/schedule'.freeze

        module_function

        def now(base_uri, channel)
          uri_for_path(base_uri, "/channel/#{channel}", {stop: Time.now.iso8601, sort: 'desc', max: 1})
        end

        def next(base_uri, channel)
          uri_for_path(base_uri, "/channel/#{channel}", {start: Time.now.iso8601, sort: 'asc', max: 1})
        end

        def uri_for_path(base_uri, path = nil, query = {})
          uri = base_uri.merge(path: "#{API_PATH}#{path}")
          uri.query_values = query
          uri
        end

        private_class_method :uri_for_path
      end
    end
  end
end
