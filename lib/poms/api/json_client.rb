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

      def execute(request)
        request = request.merge(
          body: request.body.to_json,
          headers: DEFAULT_HEADERS.merge(request.headers)
        )
        JSON.parse(Client.execute(request).body)
      end
    end
  end
end
