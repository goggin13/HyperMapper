

module HyperMapper
  module Document

    class EmbeddedCollection
      def initialize(options={})
        @klass = options[:class]
        children_hash = options[:values] ? options[:values].value : {}
        @elements = children_hash.inject({}) do |acc, attrs|
          child = @klass.load_from_attrs attrs
          acc[child.key_value] = child
          child.parent = options[:parent]
          acc
        end
      end

      def [](v)
        @elements.to_a[v][1]
      end

      def find(id)
        @elements[id]
      end

      def to_a
        @elements.map do |k, child|
          attrs = child.attribute_values_map_raw
          attrs.delete child.parent_name
          attrs
        end
      end
    end

    module ClassMethods
      
      def embedded_classes
        @embedded_classes ||= []
      end

      def embeds_many(children, options={})
        
        attribute children

        child_class = children.to_s.singularize.camelcase.constantize
        
        define_method children do
          @embedded ||= 
             EmbeddedCollection.new class: child_class,
                                    values: attribute_values_map[children],
                                    parent: self
        end
        
        embedded_classes << children
      end
      
      def embedded_in(parent, options={})
        @embedded = true
        
        attribute parent
        alias_method :parent, parent
        alias_method 'parent=', "#{parent}="

        define_method 'parent_name' do
          parent
        end
      end

      def embedded?
        @embedded ? @embedded : false  
      end
    end
  end
end
