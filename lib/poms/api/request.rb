require 'poms/api/auth'
require 'open-uri'
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

      # Executes the request.
      def call
        open uri.to_s, headers
      end

      def post
        req = Net::HTTP::Post.new(uri.path)
        https = Net::HTTP.new(uri.host, 443)
        https.use_ssl = true
        https.request(req)
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
