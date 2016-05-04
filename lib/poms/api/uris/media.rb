require 'addressable/uri'

module Poms
  module Api
    module URIs
      # Builds uri's for /media endpoints
      module Media
        API_PATH = '/v1/api/media'.freeze

        module_function

        def single(base_uri, mid)
          uri_for_path(base_uri, "/#{mid}")
        end

        def multiple(base_uri)
          uri_for_path(base_uri, '/multiple')
        end

        def descendants(base_uri, mid)
          uri_for_path(base_uri, "/#{mid}/descendants")
        end

        def members(base_uri, mid)
          uri_for_path(base_uri, "/#{mid}/members")
        end

        # URI for merged series
        def redirects(base_uri)
          uri_for_path(base_uri, '/redirects/')
        end

        def uri_for_path(base_uri, path)
          base_uri.merge(path: "#{API_PATH}#{path}")
        end

        private_class_method :uri_for_path
      end
    end
  end
end
