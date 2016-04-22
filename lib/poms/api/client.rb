require 'poms/api/drivers/net_http'
require 'poms/api/request'
require 'poms/api/auth'
require 'poms/errors'

module Poms
  module Api
    # The Client module isolates all HTTP interactions, regardless of the driver
    # module to implement the actual operations. Use the Client module to build
    # signed requests and execute them.
    #
    # @see Poms::Api::Drivers::NetHttp
    module Client
      extend Drivers::NetHttp

      module_function

      def get(uri, credentials, headers = {})
        handle_response(
          execute(
            sign(
              prepare_get(uri, headers),
              credentials
            )
          )
        )
      end

      def post(uri, body, credentials, headers = {})
        handle_response(
          execute(
            sign(
              prepare_post(uri, body, headers),
              credentials
            )
          )
        )
      end

      def handle_response(response)
        case response.code
        when 400..499 then raise Errors::HttpMissingError
        when 500..599 then raise Errors::HttpServerError
        else
          response
        end
      end

      def prepare_get(uri, headers = {})
        Request.get(uri, nil, headers)
      end

      def prepare_post(uri, body, headers = {})
        Request.post(uri, body, headers)
      end

      def sign(request, credentials, clock = Time.now)
        timestamp = clock.rfc822
        origin = credentials.origin
        message = Auth.message(request.uri, origin, timestamp)
        encoded_message = Auth.encode(credentials.secret, message)
        request['Origin'] = origin
        request['X-NPO-Date'] = timestamp
        request['Authorization'] = "NPO #{credentials.key}:#{encoded_message}"
        request
      end
    end
  end
end
