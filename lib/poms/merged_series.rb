require 'open-uri'

module Poms
  # Methods for working with the merged series api from NPO.
  module MergedSeries
    extend self

    def serie_mids
      data = open('https://rs-test.poms.omroep.nl/v1/api/media/redirects/').read
      JSON.parse(data).fetch('map')
    end
  end
end
