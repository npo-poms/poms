module Poms
  module Errors
    # Custom error to indicate that the gem has not been configured at all.
    class NotConfigured < StandardError
    end
  end
end
