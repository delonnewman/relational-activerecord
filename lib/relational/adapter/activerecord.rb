require 'relational'
require 'activerecord'

module Relational
  module Adapter
    class ActiveRecordRelation < Relation
      def dispatch?(data)
        data.is_a?(Class) and Set.new(data.ancestors).include?(ActiveRecord::Base) or data.is_a?(ActiveRecord::Relation)
      end

      def self.from(data, opts = {})
        meta = opts[:meta] || {}
        if data.is_a?(Class) and data.is_a?(ActiveRecord::Base)
          new(data.attribute_names.map(&:to_sym), data.all, meta)
        elsif data.is_a?(ActiveRecord::Relation)
          new(data.attribute_names.map(&:to_sym), data, meta)
        else
          raise Adapter::Error, "Don't know how to import data from #{data.inspect}"
        end
      end

      attr_reader :ar_relation

      def initialize(header, ar_relation, meta = {})
        super(header, ar_relation, meta)
        @ar_relation = ar_relation
      end

      def joins(*args)
        self.from(@ar_relation.joins(*args), meta: meta)
      end

      def join(other)
        if other.is_a?(Symbol) or other.is_a?(String) or other.is_a?(Hash)
          joins(other)
        else
          super(other)
        end
      end
    end
  end
end