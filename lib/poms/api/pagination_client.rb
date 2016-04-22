require 'poms/api/json_client'
# require 'pry'

module Poms
  module Api
    # This module creates lazy Enumerators to handle pagination of the Poms API
    # and performs the request on demand.
    module PaginationClient
      module_function

      def all(uri, config)
        uri.query_values = { max: 100 }
        response = Api::JsonClient.get(uri, config)
        response['items']
      end

      # response['total']

      # response['offset']
      # response['max']
    end
  end
end
