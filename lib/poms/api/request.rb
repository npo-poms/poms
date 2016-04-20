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

      attr_reader :uri, :body

      def self.get(*args)
        new(:get, *args)
      end

      def self.post(*args)
        new(:post, *args)
      end

      def initialize(method, uri, body = nil, headers = {})
        @method = method.to_sym
        unless %i(get post).include?(@method)
          raise ArgumentError, 'method should be :get or :post'
        end
        @uri = uri
        @body = body.to_s
        @headers = headers.to_h
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
