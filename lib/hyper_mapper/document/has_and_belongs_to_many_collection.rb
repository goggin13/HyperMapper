
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
        @klass.find_all(child_ids)
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
  
      def create(params={})
        item = @klass.create! params
        self.<< item
        item  
      end
      
      def create!(params={})
        create(params)
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
      
      def where
      end
      
      def remove(item)
      end
          
      def length
      end
      
      def all
      end
    end
  end
end