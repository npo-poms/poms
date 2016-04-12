module Poms
  module Errors
    # Custom Error class to signal missing authorization attributes
    class AuthenticationError < StandardError
      attr_reader :message

      def initialize(message)
        @message = message
      end
    end
  end
end
