require 'active_support/all'
require 'poms/api/uris'
require 'poms/api/json_client'
require 'poms/errors/authentication_error'
require 'poms/api/search'
require 'json'

# Main interface for the POMS gem
#
# Strategy
# 1 -- Build a request object that can be executed (PostRequest || GetRequest object)
# 2 -- Execute the request. Retry on failures (max 10?)
# 3 -- Parse responded JSON. Extract fields if necessary
module Poms
  extend self
  REQUIRED_CREDENTIAL_KEYS = [:key, :origin, :secret].freeze

  def configure
    yield config
    config.freeze
    nil
  end

  # Returns the first result for a mid if it is not an error.
  #
  # @param [String] mid MID to find in POMS
  def first(mid)
    first!(mid)
  rescue Api::Client::HttpMissingError
    nil
  end

  def first!(mid)
    Api::JsonClient.get(Api::URIs::Media.single(mid, base_uri), credentials)
  end

  def fetch(arg)
    Api::JsonClient.post(Api::URIs::Media.multiple(base_uri), Array(arg), credentials)
  end

  def descendants(mid, search_params = {})
    Api::JsonClient.post(
      Api::URIs::Media.descendants(mid, base_uri),
      Api::Search.build(search_params),
      credentials
    )
  end

  def members(mid)
    Api::JsonClient.get(Api::URIs::Media.members(mid, base_uri), credentials)
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
    @config ||= OpenStruct.new(
      base_uri: Addressable::URI.parse(ENV['POMS_BASE_URI'])
    )
  end

  def base_uri
    config.base_uri
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
