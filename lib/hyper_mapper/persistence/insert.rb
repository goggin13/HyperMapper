require 'active_support/inflector'

module HyperMapper
  module Persistence
    module ClassMethods
      attr_writer :space_name      
      
      def space_name
        @space_name ||= self.name.tableize
      end

      def create(params={})
        self.new(params).save
      end
      
      def create!(params={})
        self.new(params).save!
      end 
    end
  end
end
