require 'addressable/uri'

# This module builds URI objects for various endpoints of the POMS API
module Poms
  module URIs
    BASE_PARAMS = { scheme: 'https', host: 'rs.poms.omroep.nl' }

    module Media
      def self.single(mid)
        Addressable::URI.new(BASE_PARAMS.merge path: "/v1/api/media/#{mid}")
      end

      def self.multiple
        Addressable::URI.new(BASE_PARAMS.merge(path: '/v1/api/media/multiple'))
      end
    end
  end
end
