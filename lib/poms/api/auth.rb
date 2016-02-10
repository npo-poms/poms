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
      # @param secret The Poms API secret key
      # @param message The message that needs to be hashed.
      def self.encode(secret, message)
        sha256 = OpenSSL::Digest.new('sha256')
        digest = OpenSSL::HMAC.digest(sha256, secret, message)
        Base64.encode64(digest)
      end

      # Creates the header that is used for authenticating a request to the Poms
      # API.
      #
      # @param uri The uri that is being requested
      # @param origin The origin header
      # @param date The date as an RFC822 string
      # @param params The url params as a ruby hash
      def self.message(uri, origin, date, params = {})
        params_string = params.sort.map do |key, value|
          "#{key}:#{value}"
        end.join(',') if params.present?
        [
          "origin:#{origin}",
          "x-npo-date:#{date}",
          "uri:#{uri}",
          params_string
        ].compact.join(',')
      end
    end
  end
end
