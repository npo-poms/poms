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

  def configure
    yield config
    config.freeze
    nil
  end

  # Returns the first result for a mid if it is not an error.
  #
  # @param mid The mid to find
  def first(mid)
    item = fetch(mid)["items"][0]
    item["result"] unless item.key?("error")
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
    REQUIRED_CREDENTIAL_KEYS.each do |key|
      value = config.send(key)
      next if value.present?
      raise Errors::AuthenticationError, "#{key} must be supplied"
    end
  end

  def config
    @config ||= OpenStruct.new
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
end
