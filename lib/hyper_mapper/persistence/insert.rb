require 'active_support/inflector'

module HyperMapper
  module Persistence
    module ClassMethods
      attr_writer :space_name      
      
      def space_name
        return @space_name if @space_name
        @space_name = self.name.tableize
        if defined? Rails
          prefix = "#{Rails.application.class.parent_name.downcase}_#{Rails.env}"
          @space_name = "#{prefix}_space_name"
        end
        
        @space_name
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

        cmd = <<EOF
space #{space_name} 
key #{key_name}
attributes #{attr_names.reject(&:nil?).join ', '}
subspace #{subspaces.join ', '}
tolerate #{t} failures
EOF
        Config.client.add_space cmd
      end

      def destroy_space
        Config.client.rm_space space_name
      end
    end
  end
end
