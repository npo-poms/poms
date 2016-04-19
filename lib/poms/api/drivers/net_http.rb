require 'net/https'

module Poms
  module Api
    module Drivers
      module NetHttp
        def execute(request_description)
          uri = request_description.uri
          request =
            if request_description.get?
              Net::HTTP::Get.new(uri.path)
            elsif request_description.post?
              Net::HTTP::Post.new(uri.path)
            else
              raise ArgumentError, 'can only execute GET or POST requests'
            end
          request.body = request_description.body.to_s
          request_description.each_header do |key, value|
            request[key] = value
          end
          begin
            response =
              Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
                http.open_timeout = 5
                http.read_timeout = 5
                http.request(request)
              end
          rescue Timeout::Error,
                 Errno::EINVAL,
                 Errno::ECONNRESET,
                 EOFError,
                 Net::HTTPBadResponse,
                 Net::HTTPHeaderSyntaxError,
                 Net::ProtocolError => e
            raise HttpError,
              "An error (#{e.class}) occured while processing your request."
          end
          [response.code, response.body, response.to_hash]
        end
      end
    end
  end
end
