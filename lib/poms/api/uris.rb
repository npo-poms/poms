require 'addressable/uri'

# This module builds URI objects for various endpoints of the POMS API
module Poms
  module Api
    # Contains modules that build uri objects for various api endpoints
    module URIs
      # Builds uri's for /media endpoints
      module Media
        API_PATH = '/v1/api/media'.freeze

        module_function

        def single(mid, base_uri)
          uri_for_path(base_uri, "/#{mid}")
        end

        def multiple(base_uri)
          uri_for_path(base_uri, '/multiple')
        end

        def descendants(mid, base_uri)
          uri_for_path(base_uri, "/#{mid}/descendants")
        end

        def members(mid, base_uri)
          uri_for_path(base_uri, "/#{mid}/members")
        end

        # URI for merged series
        def redirects(base_uri)
          uri_for_path(base_uri, '/redirects/')
        end

        def uri_for_path(base_uri, path)
          base_uri.merge path: "#{API_PATH}#{path}"
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
