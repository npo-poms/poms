require 'base64'

module Poms
  module Api
    # This module can be used to create an authentication header for the Poms
    # API.
    #
    # see: http://wiki.publiekeomroep.nl/display/npoapi/Algemeen
    module Auth
      # Create an auth header for the Poms API. This is a codified string
      # consisting of a message that is hashed with a secret.
      #
      # @see message
      # @param uri An instance of an Addressable::URI of the requested uri
      # @param credentials The Poms API credentials
      # @param timestamp The time as an RFC822 string
      def self.encoded_message(uri, credentials, timestamp)
        message = message(uri, credentials.origin, timestamp)
        sha256 = OpenSSL::Digest.new('sha256')
        digest = OpenSSL::HMAC.digest(sha256, credentials.secret, message)
        Base64.encode64(digest).strip
      end

      # Creates the header that is used for authenticating a request to the Poms
      # API.
      #
      # @param origin The origin header
      # @param params The url params as a ruby hash
      def self.message(uri, origin, timestamp)
        [
          "origin:#{origin}",
          "x-npo-date:#{timestamp}",
          "uri:#{uri.path}",
          params_string(uri.query_values)
        ].compact.join(',')
      end

      def self.params_string(params)
        return unless params
        params.map { |key, value| "#{key}:#{value}" }.sort.join(',')
      end

      private_class_method :params_string
    end
  end
end
