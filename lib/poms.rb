require 'active_support/all'
require 'poms/api/uris'
require 'poms/api/json_client'
require 'poms/errors/authentication_error'
require 'poms/errors/missing_configuration_error'
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
  DEFAULT_BASE_URI = 'https://rs.poms.omroep.nl'.freeze

  def configure
    yield config
    config.freeze
    nil
  end

  # Returns the first result for a mid if it is not an error.
  #
  # @param [String] mid MID to find in POMS
  # @return [Hash, nil]
  def first(mid)
    first!(mid)
  rescue Api::Client::HttpMissingError
    nil
  end

  # Like `first`, but raises `Api::Client::HttpMissingError` when the requested
  # MID could not be found.
  #
  # @param [String] mid
  # @raise Api::Client::HttpMissingError
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

  def reset_config
    @config = nil
  end

  def default_config
    OpenStruct.new(
      key: ENV['POMS_KEY'],
      origin: ENV['POMS_ORIGIN'],
      secret: ENV['POMS_SECRET'],
      base_uri: Addressable::URI.parse(
        ENV.fetch('POMS_BASE_URI', DEFAULT_BASE_URI)
      )
    )
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
    @config ||= default_config
  end

  def base_uri
    config.base_uri or
      raise Errors::MissingConfigurationError, 'base_uri must be supplied'
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
