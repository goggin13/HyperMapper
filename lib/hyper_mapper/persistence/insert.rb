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

      def create_space(t=2)
        attr_names = attribute_meta_data.map do |k, meta|
          if meta[:key]
            nil
          elsif meta[:type].nil? || meta[:type] == :string
            k
          else
            meta[:type] = :int if meta[:type] == :datetime
            "#{meta[:type]} #{k}"
          end
        end
        subspaces = attributes.map { |k,v| k }
        embedded_classes.each do |children|
          attr_names << "map(string, string) #{children}"
          subspaces << children
        end

        cmd = <<-BASH
#{Config.path} add-space <<EOF
space #{space_name} 
key #{key_name}
attributes #{attr_names.reject(&:nil?).join ', '}
subspace #{subspaces.join ', '}
tolerate #{t} failures
EOF
BASH
        cmd
      end

      def destroy_space
        cmd = "#{Config.path} rm-space #{space_name}"
      end
    end
  end
end
