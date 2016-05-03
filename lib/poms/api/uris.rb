require 'addressable/uri'

# This module builds URI objects for various endpoints of the POMS API
module Poms
  module Api
    # Contains modules that build uri objects for various api endpoints
    module URIs
      # Builds uri's for /media endpoints
      module Media
        PATH_PREFIX = '/v1/api/media'.freeze

        module_function

        def single(mid, base_uri)
          uri_for_path("/#{mid}", base_uri)
        end

        def multiple(base_uri)
          uri_for_path('/multiple', base_uri)
        end

        def descendants(mid, base_uri)
          uri_for_path("/#{mid}/descendants", base_uri)
        end

        def members(mid, base_uri)
          uri_for_path("/#{mid}/members", base_uri)
        end

        # URI for merged series
        def redirects(base_uri)
          uri_for_path('/redirects/', base_uri)
        end

        def uri_for_path(path, base_uri)
          base_uri.merge path: "#{PATH_PREFIX}#{path}"
        end
      end

      # URI for the /schedule API
      module Schedule
        API_PATH = '/v1/api/schedule'.freeze

        module_function

        def channel(base_uri, channel)
          uri_for_path(base_uri, "/channel/#{channel}")
        end

        def uri_for_path(base_uri, path = nil)
          base_uri.merge(path: "#{API_PATH}#{path}")
        end
      end
    end
  end
end
