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

      # URI for the /schedule API
      module Schedule
        API_PATH = '/v1/api/schedule'.freeze

        module_function

        def channel(base_uri, channel, params = default_channel_params)
          base_uri.query_values = params
          uri_for_path(base_uri, "/channel/#{channel}")
        end

        def uri_for_path(base_uri, path = nil)
          base_uri.merge(path: "#{API_PATH}#{path}")
        end

        # To find the current broadcast we start looking at events from
        # yesterday until now, sort descending and take the first one.
        # It's probably not necessary to look as far back as yesterday, but we
        # do need to know the most recent one.
        def default_channel_params
          {
            max: 1,
            sort: 'desc',
            start: 1.day.ago.iso8601,
            stop: Time.now.iso8601
          }
        end

        private_class_method :default_channel_params, :uri_for_path
      end
    end
  end
end
