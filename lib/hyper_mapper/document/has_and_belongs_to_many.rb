
module HyperMapper
  module Document
    module ClassMethods
      def has_and_belongs_to_many(children, options={})

        unless options[:through]
          msg = "must specify :through for has_and_belongs_to_many"
          raise Exceptions::MissingArgumentError.new msg
        end
        
        child_class = children.to_s.classify.constantize

        define_method children do
          @child_classes ||= {}
          @child_classes[children] ||=
            HasAndBelongsToManyCollection.new class: child_class,
                                              parent: self,
                                              through: options[:through].to_s.classify.constantize
        end
      end
    end
  end
end
