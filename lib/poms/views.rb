require 'poms/connect'

# Constructs urls for Poms
module Poms
  module Views
    include Poms::Connect
    extend self

    def get(mid)
      uri = "#{base_url}/media/#{mid}"
      get_json(uri)
    end

    def by_group(mid)
      args = {
        key: "\"#{mid}\"",
        reduce: false,
        include_docs: true
      }
      uri = construct_view_url('by-group', args)
      get_json(uri)
    end

    private

    def base_url
      'http://docs.poms.omroep.nl'
    end

    def view_path
      '/media/_design/media/_view/'
    end

    def construct_view_url(view, args)
      "#{base_url}#{view_path}#{view}?#{args.to_query}"
    end
  end
end
