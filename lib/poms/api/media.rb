require 'poms/api/request'
require 'poms/api/uris'

module Poms
  module Api
    module Media
      def self.from_mid(mid, credentials)
        Poms::Api::GetRequest.new(URIs::Media.single(mid), credentials)
      end

      def self.multiple(mids, credentials)
        Poms::Api::PostRequest.new(URIs::Media.multiple, credentials, body: mids)
      end

      def self.descendants
        Poms::Api::PostRequest.new(URIs::Media.descendants, credentials, body: 'foo')
      end
    end
  end
end
