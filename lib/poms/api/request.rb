require 'forwardable'

module Poms
  module Api
    # The `Request` object is an implementation-agnostic description of an HTTP
    # request, representing a combination of an HTTP method, URI, body and
    # headers.
    class Request
      extend Forwardable
      def_delegators :@headers, :[], :[]=
      def_delegator :@headers, :each, :each_header

      attr_reader :method, :uri, :credentials, :body, :headers

      def initialize(method:, uri:, credentials: nil, body: nil, headers: {})
        @method = method.to_sym
        unless %i(get post).include?(@method)
          raise ArgumentError, 'method should be :get or :post'
        end
        @uri = uri
        @body = body || ''
        @headers = headers.to_h
        @credentials = credentials
      end

      def merge(new_attributes)
        self.class.new(attributes.merge(new_attributes))
      end

      def attributes
        {
          method: method,
          uri: uri,
          body: body,
          headers: headers,
          credentials: credentials
        }
      end

      def get?
        @method == :get
      end

      def post?
        @method == :post
      end
    end
  end
end
