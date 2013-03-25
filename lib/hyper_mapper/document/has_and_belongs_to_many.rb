module HyperMapper
  module Document
    
    class HasAndBelongsToManyCollection

    end

    module ClassMethods
      def has_and_belongs_to_many(children)

        child_class = children.to_s.singularize.camelcase.constantize 

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
