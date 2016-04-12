require 'active_support/all'
require 'poms/media'
require 'poms/errors/authentication_error'
require 'json'

# Main interface for the POMS gem
module Poms
  extend self
  attr_reader :config

  def configure
    @config ||= OpenStruct.new
    yield @config
  end

  def fetch(arg)
    assert_credentials
    if arg.is_a?(Array)
      request = Poms::Media.multiple(arg, config)
    elsif arg.is_a?(String)
      request = Poms::Media.from_mid(arg, config)
    else
      raise 'Invalid argument passed to Poms.fetch. '\
        'Please make sure to provide either a mid or an array of mid'
    end
    JSON.parse(request.get.body)
  end

  private

  def assert_credentials
    raise Errors::AuthenticationError, 'API key not supplied'    if config.key.blank?
    raise Errors::AuthenticationError, 'API secret not supplied' if config.secret.blank?
    raise Errors::AuthenticationError, 'Origin not supplied'     if config.origin.blank?
  end
end
