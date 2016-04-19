require 'addressable/uri'

# This module builds URI objects for various endpoints of the POMS API
module Poms
  module Api
    # Contains modules that build uri objects for various api endpoints
    module URIs
      BASE_PARAMS = { scheme: 'https', host: 'rs.poms.omroep.nl' }.freeze

      # Builds uri's for /media endpoints
      module Media
        module_function

        def single(mid)
          uri_for_path("/#{mid}")
        end

        def multiple
          uri_for_path('/multiple')
        end

        def descendants(mid)
          uri_for_path("/#{mid}/descendants")
        end

        def members(mid)
          uri_for_path("/#{mid}/members")
        end

        def uri_for_path(path)
          Addressable::URI.new(BASE_PARAMS.merge(path: "/v1/api/media#{path}"))
        end
      end
    end
  end
end
