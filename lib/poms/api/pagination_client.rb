require 'poms/api/json_client'

module Poms
  module Api
    # Creates lazy Enumerators to handle pagination of the Poms API and performs
    # the request on demand.
    module PaginationClient
      module_function

      def all(uri, config)
        Enumerator.new do |yielder|
          page = Page.new(uri, config)
          loop do
            page.items.each { |item| yielder << item }
            raise StopIteration if page.final?
            page = page.next_page
          end
        end
      end

      # Keep track of number of items and how many have been retrieved
      class Page
        def initialize(uri, config, offset = 0)
          @uri = uri
          @config = config
          @offset = offset
        end

        def next_page
          self.class.new(uri, config, next_index)
        end

        def final?
          next_index >= response['total']
        end

        def items
          response['items']
        end

        private

        attr_reader :config, :offset, :uri

        def response
          @response ||= begin
            uri.query_values = { offset: offset }
            Api::JsonClient.get(uri, config)
          end
        end

        def next_index
          response['offset'] + response['max']
        end
      end
    end
  end
end
