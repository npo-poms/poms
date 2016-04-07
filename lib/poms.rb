require 'active_support/all'
require 'poms/media'
require 'poms/errors/authentication_error'
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
    fail Errors::AuthenticationError, 'API key not supplied' unless @key.present?
    fail Errors::AuthenticationError, 'API secret not supplied' unless @secret.present?
    fail Errors::AuthenticationError, 'Origin not supplied' unless @origin.present?
  end
end
