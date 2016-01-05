require 'open-uri'

module Poms
  # Methods for working with the merged series api from NPO.
  module MergedSeries
    include Enumerable
    extend self

    def serie_mids
      data = open('https://rs-test.poms.omroep.nl/v1/api/media/redirects/').read
      JSON.parse(data).fetch('map')
    end

    def each
      serie_mids.each do |old_mid, new_mid|
        yield(old_mid, new_mid)
      end
    end
  end
end
