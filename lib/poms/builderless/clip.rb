require 'poms/fields'

module Poms
  module Builderless
    # A single broadcast fetched from Poms
    class Clip
      def initialize(hash)
        @hash = hash
      end

      def title
        Fields.title(@hash)
      end

      def mid
        @hash['mid']
      end

      def video_url
        return if @hash['locations'].empty?
        @hash['locations'].first['programUrl']
      end

      def image_id
        images = Fields.images(@hash)
        return if images.empty?
        Fields.image_id(images.first)
      end
    end
  end
end
