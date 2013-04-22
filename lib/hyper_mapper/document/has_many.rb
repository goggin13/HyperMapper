module HyperMapper
  module Document
    module ClassMethods
      def has_many(children)

        child_class = children.to_s.classify.constantize

        define_method children do
          @child_classes ||= {}
          @child_classes[children] ||=
            HasManyCollection.new class: child_class,
                                  parent: self
        end
      end

      def belongs_to(parent)
        define_method parent do
          parent_klass = parent.to_s.classify.constantize
          foreign_key = "#{parent_klass.foreign_key}"
          predicate = {}
          predicate[parent_klass.key_name] = self.send(foreign_key)
          (parent_klass.where predicate)[0]
        end
      end
    end
  end
end
