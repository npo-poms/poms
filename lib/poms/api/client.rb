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
      module_function

      def execute(request)
        handle_response(Drivers::NetHttp.execute(Auth.sign(request)))
      end

      def handle_response(response)
        case response.code
        when 400..499 then raise Errors::HttpMissingError, response.code
        when 500..599 then raise Errors::HttpServerError, response.code
        else
          response
        end
      end
    end
  end
end
