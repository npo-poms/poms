require 'poms/api/request'

module Poms
  module Media
    def self.from_mid(mid, key, secret, origin)
      Poms::Api::Request.new("https://rs.poms.omroep.nl/v1/api/media/" + mid, key, secret, origin)
    end
  end
end
