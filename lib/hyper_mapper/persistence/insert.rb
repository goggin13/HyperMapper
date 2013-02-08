require 'active_support/inflector'

module HyperMapper
  module Persistence
    module ClassMethods
      attr_writer :space_name      
      
      def space_name
        @space_name ||= self.name.tableize
      end

      def create(params={})
        key = params.delete key_name
        HyperMapper::Config.client.put(space_name, key, params)
      end
      
      def create!(params={})
        create(params)
      end 
    end
  end
end
