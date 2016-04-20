module Poms
  module Api
    # Response is an implementation-agnostic representation of an HTTP-response,
    # composing a HTTP status code, body and hash of headers.
    class Response
      # @return [Fixnum]
      attr_reader :code

      # @return [String]
      attr_reader :body

      # @return [Hash]
      attr_reader :headers

      def initialize(code, body, headers)
        @code = code.to_i
        @body = body.to_s
        @headers = headers.to_h
        freeze
      end

      def eql?(other)
        other.is_a?(self.class) &&
          code == other.code &&
          body == other.body &&
          headers == other.headers
      end
      alias == eql?
    end
  end
end
