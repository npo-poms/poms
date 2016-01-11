module Poms
  # Mixin for a class that has ancestors.
  module HasAncestors
    module ClassMethods
    end

    module InstanceMethods
      def series
        return @series if @series
        return [] if descendant_of.blank?
        descendant_series = descendant_of.reject do |obj|
          obj.class != Poms::Series
        end
        if descendant_series.blank?
          descendant_of
        else
          descendant_series
        end
      end

      def serie
        series.first
      end

      def serie_mid
        return nil if serie.nil?
        serie.mid_ref || serie.mid
      end

      def ancestor_mids
        return @ancestor_mids if @ancestor_mids
        @ancestor_mids = (descendant_of_mids +
          episode_of_mids).flatten.compact.uniq
      end

      def descendant_of_mids
        descendant_of.map(&:mid_ref)
      rescue
        []
      end

      def episode_of_mids
        episode_of.map(&:mid_ref)
      rescue
        []
      end
    end

    def self.included(receiver)
      receiver.extend ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
