module Poms
  module Errors
    # Generic Poms error that all other errors inherit from. This allows you to
    # rescue any exception from this library in your application code.
    PomsError = Class.new(StandardError)

    # Custom Error class to signal missing authorization attributes
    AuthenticationError = Class.new(PomsError)

    # Base exception for all Poms-specific HTTP errors.
    HttpError = Class.new(PomsError)

    # Wrapper exception for dealing with driver-agnostic 404 responses.
    HttpMissingError = Class.new(HttpError)

    # Wrapper exception for dealing with driver-agnostic 500 responses.
    HttpServerError = Class.new(HttpError)

    # Custom error than can be used to indicate a required configuration value
    # is missing.
    MissingConfigurationError = Class.new(PomsError)

    # Custom error to indicate that the gem has not been configured at all.
    NotConfigured = Class.new(PomsError)
  end
end
