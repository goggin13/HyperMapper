
module HyperMapper
  module Document
    
    class HasAndBelongsToManyCollection
      attr_reader :join_table

      def initialize(options={})
        @klass = options[:class]
        @parent = options[:parent]
        @join_table = 'join_table'
      end
    end

    module ClassMethods
      def has_and_belongs_to_many(children)

        child_class = children.to_s.classify

        define_method children do
          @child_classes ||= {}
          @child_classes[children] ||=
            HasAndBelongsToManyCollection.new class: child_class,
                                              parent: self
        end
      end
    end
  end
end
