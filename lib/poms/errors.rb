module Poms
  module Errors
    # Custom Error class to signal missing authorization attributes
    AuthenticationError = Class.new(StandardError)

    # Base exception for all Poms-specific HTTP errors.
    class HttpError < StandardError
    end

    # Wrapper exception for dealing with driver-agnostic 404 responses.
    class HttpMissingError < HttpError
    end

    # Wrapper exception for dealing with driver-agnostic 500 responses.
    class HttpServerError < HttpError
    end

    # Custom error than can be used to indicate a required configuration value
    # is missing.
    class MissingConfigurationError < StandardError
    end

    # Custom error to indicate that the gem has not been configured at all.
    class NotConfigured < StandardError
    end
  end
end
