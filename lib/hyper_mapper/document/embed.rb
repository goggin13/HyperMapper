require 'json'

module HyperMapper
  module Document
    module ClassMethods
      
      def embedded_classes
        @embedded_classes ||= []
      end

      def embeds_many(children, options={})
        
        attribute children, embedded: true

        child_class = children.to_s.classify.constantize
        
        define_method children do
          @embedded_collections ||= {}
          @embedded_collections[children] ||= 
             EmbeddedCollection.new class: child_class,
                                    values: attribute_values_map[children],
                                    parent: self
        end
        
        embedded_classes << children
      end
      
      def embedded_in(parent, options={})
        @embedded = true
        
        attribute parent, embedded_in: true
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
