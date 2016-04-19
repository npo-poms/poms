require 'poms/api/client'

module Poms
  module Api
    module JsonClient
      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }.freeze

      module_function

      def get(uri, credentials, headers = {})
        response = Client.get(
          uri,
          credentials,
          DEFAULT_HEADERS.merge(headers)
        )
        JSON.parse(response[1])
      end

      def post(uri, body, credentials, headers = {})
        response = Client.post(
          uri,
          body.to_json,
          credentials,
          DEFAULT_HEADERS.merge(headers)
        )
        JSON.parse(response[1])
      end
    end
  end
end
