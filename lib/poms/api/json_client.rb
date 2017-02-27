require 'poms/api/client'

module Poms
  module Api
    # The JsonClient module is a wrapper around the regular Client module. It
    # requests and responses to handle JSON-formatted bodies.
    module JsonClient
      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }.freeze

      module_function

      def get(uri, credentials, headers = {})
        execute(
          Request.new(
            method: :get,
            uri: uri,
            headers: headers,
            credentials: credentials
          )
        )
      end

      def post(uri, body, credentials, headers = {})
        execute(
          Request.new(
            method: :post,
            uri: uri,
            body: body,
            headers: headers,
            credentials: credentials
          )
        )
      end

      def execute(request)
        r = Request.new(request.attributes.merge({
          body: request.body.to_json,
          headers: DEFAULT_HEADERS.merge(request.headers)
        }))
        JSON.parse(Client.execute(r).body)
      end
    end
  end
end
