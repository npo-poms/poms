require 'open-uri'

module Poms
  # Methods for working with the merged series api from NPO.
  module MergedSeries
    include Enumerable
    extend self

    API_URL = 'https://rs-test.poms.omroep.nl/v1/api/media/redirects/'.freeze

    def serie_mids(api_url)
      data = open(api_url).read
      JSON.parse(data).fetch('map')
    end

    def each
      serie_mids(API_URL).each do |old_mid, new_mid|
        yield(old_mid, new_mid)
      end
    end
  end
end
