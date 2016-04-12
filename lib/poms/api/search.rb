module Poms
  module Api
    module Search
      module_function

      def build(options)
        all = options.map do |key, value|
          case key
          when :start_time
            date_params('begin', Timestamp.to_unix_ms(value))
          when :end_time
            date_params('end', Timestamp.to_unix_ms(value))
          when :type
            { 'facets' => { 'subsearch' => { 'types' => value } } }
          end
        end
        all.reduce(&:deep_merge)
      end

      def date_params(key, value)
        { 'searches' => { 'sortDates' => { key => value } } }
      end
    end
  end
end
