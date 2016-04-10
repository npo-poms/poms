require 'poms/api/auth'
require 'net/https'

module Poms
  module Api
    # A request to the Poms API. Does the authentication and allows you to
    # execute the request.
    class Request
      attr_reader :uri, :credentials
      # Create a new request to the Poms API. The request is initialized with a
      # URI to be called and the key, secret and origin that are needed for
      # authentication.
      #
      # @param uri An instance of an Addressable::URI of the requested uri
      # @param key The api key
      # @param secret The secret that goes with the api key
      # @param origin The whitelisted origin for this api key
      def initialize(uri, credentials)
        @uri = uri
        @credentials = credentials
      end

      # Executes a GET request
      def get
        req = Net::HTTP::Get.new(uri.path)
        headers.each { |key, val| req[key] = val }
        execute_ssl_request(uri.host, req)
      end

      # Executes a POST request with post body
      #
      # @param data The data object to be submitted as request body
      def post(data = {})
        req = Net::HTTP::Post.new(uri.path)
        req.body = data.to_json
        headers.each { |key, val| req[key] = val }
        execute_ssl_request(uri.host, req)
      end

      private

      def execute_ssl_request(host, request)
        Net::HTTP.start(host, 443, use_ssl: true) do |http|
          http.request(request)
        end
      end

      def headers
        date = Time.now.rfc822
        message = Auth.message(uri, credentials.origin, date)
        encoded_message = Auth.encode(credentials.secret, message)
        {
          'Origin' => credentials.origin,
          'X-NPO-Date' => date,
          'Authorization' => "NPO #{credentials.key}:#{encoded_message}",
          'Content-Type' => 'application/json'
        }
      end
    end
  end
end
