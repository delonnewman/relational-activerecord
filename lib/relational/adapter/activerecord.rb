require 'relational'
require 'activerecord'

module Relational
  module Adapter
    class ActiveRecord
      def dispatch?(data)
        data.is_a?(Class) and Set.new(data.ancestors).include?(ActiveRecord::Base) or data.is_a?(ActiveRecord::Relation)
      end

      def self.from(data)
        if data.is_a?(Class) and data.is_a?(ActiveRecord::Base)
          Relational::Relation.new(data.attribute_names.map(&:to_sym), data.all)
        elsif data.is_a?(ActiveRecord::Relation)
          Relational::Relation.new(data.attribute_names.map(&:to_sym), data)
        else
          raise Adapter::Error, "Don't know how to import data from #{data.inspect}"
        end
      end
    end
  end
end