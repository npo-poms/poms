require 'poms/errors/http_error'

module Poms
  module Errors
    # Wrapper exception for dealing with driver-agnostic 404 responses.
    class HttpMissingError < HttpError
    end
  end
end
