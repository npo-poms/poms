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

  REQUIRED_CREDENTIAL_KEYS = %i(key origin secret).freeze

  attr_reader :config

  def configure
    @config ||= OpenStruct.new
    yield @config
  end

  def credentials
    @credentials ||= begin
      assert_credentials_presence
      OpenStruct.new(
        key: config.key,
        origin: config.origin,
        secret: config.secret
      )
    end
  end

  def fetch(arg)
    request = Api::Media.multiple(Array(arg), credentials)
    JSON.parse(request.execute.body)
  end

  def descendants(mid, search_params = {})
    request = Api::Media.descendants(mid, credentials, search_params)
    JSON.parse(request.execute.body)
  end

  private

  def assert_credentials_presence
    REQUIRED_CREDENTIALS.each do |key|
      value = config.send(key)
      next if value.present?
      raise Errors::AuthenticationError, "#{key} must be supplied"
    end
  end
end
