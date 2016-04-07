require 'active_support/all'
require 'poms/api/request'
require 'json'

module Poms
  extend self

  def init(key:, secret:, origin:)
    @key = key
    @secret = secret
    @origin = origin
  end

  def media(mid)
    assert_credentials
    request = Poms::Api::Request.new("https://rs.poms.omroep.nl/v1/api/media/" + mid, @key, @secret, @origin)
    JSON.parse(request.call.read)
  end

  private

  def assert_credentials
    # Assert existence of @key, @secret and @origin and throw if necessary
  end
end
