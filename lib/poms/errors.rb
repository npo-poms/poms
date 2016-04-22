module Poms
  module Errors
    # Custom Error class to signal missing authorization attributes
    AuthenticationError = Class.new(StandardError)

    # Base exception for all Poms-specific HTTP errors.
    HttpError = Class.new(StandardError)

    # Wrapper exception for dealing with driver-agnostic 404 responses.
    HttpMissingError = Class.new(HttpError)

    # Wrapper exception for dealing with driver-agnostic 500 responses.
    HttpServerError = Class.new(HttpError)

    # Custom error than can be used to indicate a required configuration value
    # is missing.
    MissingConfigurationError = Class.new(StandardError)

    # Custom error to indicate that the gem has not been configured at all.
    NotConfigured = Class.new(StandardError)
  end
end
