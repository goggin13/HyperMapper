require 'active_support/inflector'

module HyperMapper
  module Persistence

    def save
      if self.class.embedded?
        parent.save
      else
        persist if valid?
      end
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
 

