module HyperMapper
  module Document
    
    class HasManyCollection
      attr_accessor :foreign_key

      def initialize(options={})
        @klass = options[:class]
        @parent = options[:parent]
        @foreign_key = "#{@parent.class.name.underscore}_id"
      end

      def [](v)
        all[v]
      end
      
      def find(id)
        predicate = {}
        predicate[foreign_key] = @parent.key_value
        predicate[@klass.key_name.to_s] = id
        (@klass.where predicate)[0]
      end

      def all
        predicate = {}
        predicate[foreign_key] = @parent.key_value
        @klass.where predicate
      end

      def first
        [0]
      end
    end

    module ClassMethods
      def has_many(children)

        child_class = children.to_s.singularize.camelcase.constantize 

        define_method children do
          @child_classes ||= {}
          @child_classes[children] ||=
            HasManyCollection.new class: child_class,
                                  parent: self
        end
      end
    end
  end
end
