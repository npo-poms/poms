require 'base64'

module Poms
  module Api
    # This module can be used to create an authentication header for the Poms
    # API.
    #
    # see: http://wiki.publiekeomroep.nl/display/npoapi/Algemeen
    module Auth
      module_function

      extend SingleForwardable

      delegate %i(origin secret key) => :@credentials

      # @param credentials The Poms API credentials
      # @param request The prepared request
      def sign(request, credentials, clock = Time.now)
        @credentials = credentials
        timestamp = clock.rfc822
        message = generate_message(request.uri, timestamp)

        request['Origin'] = origin
        request['X-NPO-Date'] = timestamp
        request['Authorization'] = "NPO #{key}:#{encoded_message(message)}"
        request
      end

      # Create an auth header for the Poms API. This is a codified string
      # consisting of a message that is hashed with a secret.
      def encoded_message(message)
        sha256 = OpenSSL::Digest.new('sha256')
        digest = OpenSSL::HMAC.digest(sha256, secret, message)
        Base64.encode64(digest).strip
      end

      # Creates the header that is used for authenticating a request to the Poms
      # API.
      def generate_message(uri, timestamp)
        [
          "origin:#{origin}",
          "x-npo-date:#{timestamp}",
          "uri:#{uri.path}",
          params_string(uri.query_values)
        ].compact.join(',')
      end

      def params_string(params)
        return unless params
        params.map { |key, value| "#{key}:#{value}" }.sort.join(',')
      end

      private_class_method :generate_message, :encoded_message, :params_string
    end
  end
end
