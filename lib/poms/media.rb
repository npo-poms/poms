require 'poms/api/request'
require 'poms/uris'

module Poms
  module Media
    def self.from_mid(mid, credentials)
      Poms::Api::GetRequest.new(Poms::URIs::Media.single(mid), credentials)
    end

    def self.multiple(mids, credentials)
      Poms::Api::PostRequest.new(Poms::URIs::Media.multiple, credentials, body: mids)
    end
  end
end
