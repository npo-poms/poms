require 'open-uri'

module Poms
  # Methods for working with the merged series api from NPO.
  module MergedSeries
    include Enumerable
    extend self

    API_URL = 'https://rs-test.poms.omroep.nl/v1/api/media/redirects/'.freeze

    # Gets the merged serie mids as a hash. Expects a JSON response from
    # the server with a `map` key.
    #
    # @param api_url the API url to query
    # @return [Hash] a hash with old_mid => new_mid pairs
    def serie_mids(api_url)
      data = open(api_url).read
      JSON.parse(data).fetch('map')
    end

    # Loops over the serie mids of the default api url.
    def each
      serie_mids(API_URL).each do |old_mid, new_mid|
        yield(old_mid, new_mid)
      end
    end
  end
end
