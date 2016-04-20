module Poms
  module Errors
    # Custom error than can be used to indicate a required configuration value
    # is missing.
    class MissingConfigurationError < StandardError
    end
  end
end
