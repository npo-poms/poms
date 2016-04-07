require 'active_support/all'
require 'poms/media'
require 'poms/errors/authentication_error'
require 'json'

# Main interface for the POMS gem
module Poms
  extend self

  def init(key:, secret:, origin:)
    @key = key
    @secret = secret
    @origin = origin
  end

  def fetch(arg)
    assert_credentials
    if arg.is_a?(Array)
      request = Poms::Media.multiple(arg, @key, @secret, @origin)
    elsif arg.is_a?(String)
      request = Poms::Media.from_mid(arg, @key, @secret, @origin)
    else
      fail 'Invalid argument passed to Poms.fetch. '\
        'Please make sure to provide either a mid or an array of mid'
    end
    JSON.parse(request.call.read)
  end

  private

  def assert_credentials
    fail Errors::AuthenticationError, 'API key not supplied' unless @key.present?
    fail Errors::AuthenticationError, 'API secret not supplied' unless @secret.present?
    fail Errors::AuthenticationError, 'Origin not supplied' unless @origin.present?
  end
end
