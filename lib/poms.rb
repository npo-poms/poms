require 'active_support/all'
require 'poms/api/media'
require 'poms/api/search'
require 'poms/errors/authentication_error'
require 'json'

# Main interface for the POMS gem
#
# Strategy
# 1 -- Build a request object that can be executed (PostRequest || GetRequest object)
# 2 -- Execute the request. Retry on failures (max 10?)
# 3 -- Parse responded JSON. Extract fields if necessary
module Poms
  extend self

  def configure
    yield config
  end

  def fetch(arg)
    assert_credentials
    request = Api::Media.multiple(Array(arg), config)
    JSON.parse(request.execute.body)
  end

  def descendants(mid, search_params)
    assert_credentials
    request = Api::Media.descendants(mid, config, search_params)
    JSON.parse(request.execute.body)
  end

  private

  def config
    @config ||= OpenStruct.new
  end

  def assert_credentials
    raise Errors::AuthenticationError, 'API key not supplied'    if config.key.blank?
    raise Errors::AuthenticationError, 'API secret not supplied' if config.secret.blank?
    raise Errors::AuthenticationError, 'Origin not supplied'     if config.origin.blank?
  end
end
