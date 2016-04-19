require 'poms/api/drivers/net_http'
require 'poms/api/request'
require 'poms/api/auth'

module Poms
  module Api
    module Client
      extend Drivers::NetHttp

      HttpError = Class.new(StandardError)
      HttpMissingError = Class.new(HttpError)
      HttpServerError = Class.new(HttpError)

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
        code, _body, _headers = response
        case code.to_i
        when 400..499 then raise HttpMissingError
        when 500..599 then raise HttpServerError
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
        message = Auth.message(request.uri, credentials.origin, timestamp)
        encoded_message = Auth.encode(credentials.secret, message)
        request['Origin'] = credentials.origin
        request['X-NPO-Date'] = timestamp
        request['Authorization'] = "NPO #{credentials.key}:#{encoded_message}"
        request
      end
    end
  end
end
