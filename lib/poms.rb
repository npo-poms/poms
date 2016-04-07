require 'active_support/all'
require 'poms/media'
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
    request = Poms::Media.from_mid(mid, @key, @secret, @origin)
    JSON.parse(request.call)
  end

  private

  def assert_credentials
    # Assert existence of @key, @secret and @origin and throw if necessary
  end
end
