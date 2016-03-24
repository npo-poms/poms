module Poms
  # Functionality for manipulating Poms timestamps
  module Timestamp
    module_function

    def convert(poms_timestamp)
      return unless poms_timestamp
      Time.at(poms_timestamp / 1000).to_datetime
    end
  end
end
