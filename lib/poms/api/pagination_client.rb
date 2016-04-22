require 'poms/api/json_client'
# require 'pry'

module Poms
  module Api
    # This module creates lazy Enumerators to handle pagination of the Poms API
    # and performs the request on demand.
    module PaginationClient
      module_function

      def all(uri, config)
        # uri.query_values = { max: 100 }
        index = 0
        Enumerator.new do |yielder|
          loop do
            uri.query_values = { offset: index }
            p uri
            response = Api::JsonClient.get(uri, config)
            total = response['total']
            offset = response['offset']
            amount = response['max']
            response['items'].each do |item|
              yielder.yield item
            end
            raise StopIteration if offset+amount >= total
            index = amount+index
          end
        end
      end
    end
  end
end
