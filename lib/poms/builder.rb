require 'ostruct'
require 'active_support/all'

module Poms
  class Builder
    SUPPORTED_CLASSES = %w(Broadcast Season Series Views Typeless)

    def self.process_hash(hash)
      return unless hash
      underscored_hash = hash.each_with_object({}) { |(k, v), res| res[k.underscore] = v }
      class_name = (underscored_hash['type'] || 'Typeless').capitalize
      class_name = pomsify_class_name(class_name)
      begin
        klass = Poms.const_get class_name
      rescue NameError
        # c = Class.new(Poms::NestedOpenStruct)
        klass = Poms.const_set class_name, Class.new(Poms::Builder::NestedOpenStruct)
      end
      klass.send(:new, underscored_hash)
    end

    def self.pomsify_class_name(class_name)
      class_name = 'Poms' + class_name unless SUPPORTED_CLASSES.include? class_name
      class_name
    end

    class NestedOpenStruct < OpenStruct
      include Poms::Base

      def initialize(hash)
        @hash = hash
        @hash.each do |k, v|
          process_key_value(k, v)
        end
        super hash
      end

      def process_key_value(k, v)
        case v
        when Array
          process_array(k, v)
        when Hash
          @hash.send('[]=', k, Poms::Builder.process_hash(v))
        when String, Integer
          case k
          when 'start', 'end', 'sort_date'
            @hash.send('[]=', k, Time.at(v / 1000))
          end
        when NilClass, FalseClass, TrueClass, Time, Poms::Typeless
          # do nothing
        else
          fail Poms::Exceptions::UnkownStructure, "Error processing #{v.class}: #{v}, which was expected to be a String or Array"
        end
      end

      def process_array(key, value)
        struct_array = value.map do |element|
          process_element(element)
        end
        @hash.send('[]=', key, struct_array)
      end

      def process_element(element)
        case element
        when String, Integer
          element
        when Hash
          Poms::Builder.process_hash element
        else
          fail Poms::Exceptions::UnkownStructure, "Error processing #{element}: which was expected to be a String nor a Hash"
        end
      end
    end
  end

  module Exceptions
    class UnkownStructure < StandardError
    end
  end
end
