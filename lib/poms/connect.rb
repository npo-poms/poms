module Poms
  # Module that gets json from a url.
  module Connect
    def get_json(uri)
      JSON.parse(open(uri).read)
    rescue OpenURI::HTTPError => e
      raise e unless e.message.match(/404/)
      nil
    end
  end
end
