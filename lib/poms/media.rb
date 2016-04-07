require 'poms/api/request'
require 'poms/uris'

module Poms
  module Media
    def self.from_mid(mid, key, secret, origin)
      Poms::Api::Request.new(Poms::URIs::Media.single(mid), key, secret, origin)
    end

    def self.multiple(mids, key, secret, origin)
      Poms::Api::Request.new(Poms::URIs::Media.multiple(mids), key, secret, origin)
    end
  end
end
