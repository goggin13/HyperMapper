module HyperMapper
  module Document
    
    class HasManyCollection
      include Enumerable
      attr_accessor :foreign_key

      def initialize(options={})
        @klass = options[:class]
        @parent = options[:parent]
        @foreign_key = @parent.model_name.foreign_key
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
        self.send('[]', 0)
      end

      def each
        all.each { |r| yield(r) }
      end

      def create!(attrs)
        attrs[foreign_key] = @parent.key_value
        @klass.create! attrs
      end

      def <<(child)
        child.send("#{@foreign_key}=", @parent.key_value)
        child.save
      end
    end

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
          foreign_key = "#{parent}_id"
          parent_klass = parent.to_s.classify.constantize
          predicate = {}
          predicate[parent_klass.key_name] = self.send(foreign_key)
          (parent_klass.where predicate)[0]
        end
      end
    end
  end
end
