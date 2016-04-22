require 'poms/errors/http_error'

module Poms
  module Errors
    # Wrapper exception for dealing with driver-agnostic 500 responses.
    class HttpServerError < HttpError
    end
  end
end
