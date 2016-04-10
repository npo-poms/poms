require 'poms/api/request'
require 'poms/uris'

module Poms
  module Media
    def self.from_mid(mid, credentials)
      Poms::Api::Request.new(Poms::URIs::Media.single(mid), credentials)
    end

    def self.multiple(mids, credentials)
      Poms::Api::Request.new(Poms::URIs::Media.multiple(mids), credentials)
    end
  end
end
