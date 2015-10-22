# Gets fields from Poms results
module Poms
  module Fields
    extend self

    # Returns the title, main by default
    def title(item, options = {type: 'MAIN'})
      item['titles'].find {|title| title['type'] == options[:type]}['value']
    end

    # Returns the images from the hash
    def images(item)
      item['images']
    end

    # Extracts the image id from an image hash
    # Expects a hash of just an image from POMS
    def image_id(image)
      image['imageUri'].split(':').last
    end
  end
end
