require 'addressable/uri'

module Poms
  module Api
    module Uris
      # URI for the /schedule API
      module Schedule
        API_PATH = '/v1/api/schedule'.freeze

        module_function

        def now(base_uri)
          uri_for_path(base_uri, "/net/ZAPP/now")
        end

        def now_for_channel(base_uri, channel)
          uri_for_path(base_uri, "/channel/#{channel}/now")
        end

        def next(base_uri)
          uri_for_path(base_uri, "/net/ZAPP/next")
        end

        def next_for_channel(base_uri, channel)
          uri_for_path(base_uri, "/channel/#{channel}/next")
        end

        def uri_for_path(base_uri, path = nil)
          base_uri.merge(path: "#{API_PATH}#{path}")
        end

        private_class_method :uri_for_path
      end
    end
  end
end
