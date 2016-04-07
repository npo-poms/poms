require 'poms/api/auth'
require 'open-uri'
require 'addressable/uri'

module Poms
  module Api
    # A request to the Poms API. Does the authentication and allows you to
    # execute the request.
    class Request
      # Create a new request to the Poms API. The request is initialized with a
      # URI to be called and the key, secret and origin that are needed for
      # authentication.
      #
      # @param uri An instance of an Addressable::URI of the requested uri
      # @param key The api key
      # @param secret The secret that goes with the api key
      # @param origin The whitelisted origin for this api key
      def initialize(uri, key, secret, origin)
        @uri = uri
        @key = key
        @secret = secret
        @origin = origin
      end

      # Executes the request.
      def call
        open @uri.to_s, headers
      end

      def headers
        date = Time.now.rfc822
        origin = @origin
        message = Auth.message(@uri, @origin, date)
        encoded_message = Auth.encode(@secret, message)
        {
          'Origin' => origin,
          'X-NPO-Date' => date,
          'Authorization' => "NPO #{@key}:#{encoded_message}",
          'accept' => 'application/json'
        }
      end
    end
  end
end
