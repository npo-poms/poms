module Poms
  module Api
    # Map search parameters to POMS specific format
    module Search
      TIME_PARAMS = {
        start_time: 'begin',
        end_time: 'end'
      }.freeze

      def self.build(options)
        all = options.map do |key, value|
          case key
          when :start_time, :end_time
            time_params(key, value)
          when :type
            { 'facets' => { 'subsearch' => { 'types' => value } } }
          end
        end
        all.reduce(&:deep_merge)
      end

      private_class_method

      def self.time_params(key, value)
        {
          'searches' => {
            'sortDates' => {
              TIME_PARAMS[key] => Timestamp.to_unix_ms(value)
            }
          }
        }
      end
    end
  end
end
