
module HyperMapper
  module Document
    
    class HasAndBelongsToManyCollection
      include Enumerable

      def initialize(options={})
        @klass = options[:class]
        @parent = options[:parent]
        @join_class = options[:through]
        @parent_class = @parent.class
      end
      
      def child_ids
        return [] unless @parent.key_value
        params = {}
        params[@parent_class.foreign_key] = @parent.key_value
        @join_class.where(params).map { |r| r.send(@klass.foreign_key) }
      end

      def child_collection 
        params = {}
        child_ids.inject([]) do |acc, id|
          c = @klass.find(id)
          acc << c if c
          acc
        end
        # params[@klass.key_name.to_s] = child_ids
        # @klass.where(params)
      end

      def collection
         @cached_collection ||= child_collection 
      end
      
      def <<(item)
        params = {}
        params[@parent_class.foreign_key] = @parent.key_value
        params[@klass.foreign_key] = item.key_value
        @join_class.create! params
      end

      def [](v)
        collection[v]
      end

      def each
        collection.each { |c| yield(c) }
      end

      def first
        self[0]
      end
      
      def create!(params={})
        item = @klass.create! params
        self.<< item
        item
      end

      def build(params={})
        item = @klass.new params
        self.<< item
        item 
      end

      def find(id)
        return nil unless child_ids.include?(id)
        @klass.find(id)
      end
    end

    module ClassMethods
      def has_and_belongs_to_many(children, options={})

        unless options[:through]
          raise Exceptions::MissingArgumentError.new("must specify :through for has_and_belongs_to_many")
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
