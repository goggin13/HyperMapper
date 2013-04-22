require 'active_support/inflector'

module HyperMapper
  module Persistence
    module ClassMethods
      attr_writer :space_name      
      
      def space_name
        @space_name ||= self.name.tableize
      end

      def create(params={})
        verify_attr_accessible! params
        instance = self.new(params)
        instance.save
        instance
      end
      
      def create!(params={})
        instance = create(params)
        if instance.errors.any?
          msg = instance.errors.full_messages[0]
          raise Exceptions::ValidationException.new msg
        end
        
        instance
      end 

      # def create_space
      #   cmd = '/home/goggin/projects/install/bin/hyperdex '
      #   cmd += 'add-space '
      #   cmd += "space #{space_name} "
      #   cmd += "key #{keyname} "
      #   cmd += "attributes "
      #   cmd += "subspace "
      #   cmd += "tolerate 2 failures"
      #   system(cmd)
      # end
      # 
      # def destroy_space
      #   cmd = '/home/goggin/projects/install/bin/hyperdex '
      #   cmd += "rm-space #{space_name}"
      # end
    end
  end
end
