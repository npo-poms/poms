# Constructs urls for Poms
module Poms
  module Views
    extend self

    def by_group(mid)
      args = {
        key: "\"#{mid}\"",
        reduce: false,
        include_docs: true
      }
      construct_view_url('by-group', args)
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
