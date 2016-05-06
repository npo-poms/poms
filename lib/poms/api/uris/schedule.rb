require 'addressable/uri'

module Poms
  module Api
    module Uris
      # URI for the /schedule API
      module Schedule
        API_PATH = '/v1/api/schedule'.freeze

        module_function

        def now(base_uri, channel)
          uri_for_path(base_uri, "/channel/#{channel}/now")
        end

        def next(base_uri, channel)
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
