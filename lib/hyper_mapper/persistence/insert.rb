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

      def create_space
        cmd = '/home/goggin/projects/install/bin/hyperdex '
        cmd += 'add-space '
        cmd += "space #{space_name} "
        cmd += "key #{keyname} "
        cmd += "attributes "
        cmd += "subspace "
        cmd += "tolerate 2 failures"
        system(cmd)
      end

      def destroy_space
        cmd = '/home/goggin/projects/install/bin/hyperdex '
        cmd += "rm-space #{space_name}"
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
