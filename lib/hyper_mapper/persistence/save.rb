require 'active_support/inflector'

module HyperMapper
  module Persistence
    def save
      persist if valid?
      self
    end

    def save!
      persist
      self
    end
    
    def key_value
      attribute_values_map_raw[self.class.key_name]
    end

    private 
      
      def persist
        attrs = attribute_values_map_raw
        key = attrs.delete self.class.key_name
        HyperMapper::Config.client.put(self.class.space_name, key, attrs) if key
      end
  end
end
 

