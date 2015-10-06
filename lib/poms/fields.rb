# Gets fields from Poms results
module Poms
  module Fields
    extend self

    # Returns the title, main by default
    def title(item, options = {type: 'MAIN'})
      item['titles'].find {|title| title['type'] == options[:type]}['value']
    end
  end
end
