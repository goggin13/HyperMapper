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
  
    def save
      persist if valid?
      self
    end

    def save!
      persist
      self
    end

    private 
      
      def persist
        key = attribute_values_map[self.class.key_name]
        if key
          attrs = attribute_values_map_raw
          attrs.delete self.class.key_name
          HyperMapper::Config.client.put(self.class.space_name,
                                        key.value, 
                                        attrs)
        end
      end
  end
end
