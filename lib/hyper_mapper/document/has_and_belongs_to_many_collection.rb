
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
        item.save unless item.persisted?
        @join_class.create! params
      end

      def each
        child_collection.each { |c| yield(c) }
      end
  
      def create(params={})
        item = @klass.create params
        self.<< item if item.valid?
        item
      end
      
      def create!(params={})
        item = @klass.create! params
        self.<< item
        item
      end

      def build(params={})
        item = @klass.new params
        item 
      end

      def find(id)
        return nil unless child_ids.include?(id)
        @klass.find(id)
      end
      
      def where(params={})
        params[@klass.key_name] = child_ids
        @klass.where params
      end
      
      def remove(item)
        params = {}
        params[@parent_class.foreign_key] = @parent.key_value
        params[item.class.foreign_key] = item.key_value
        @join_class.where(params).map(&:destroy)
      end
          
      def length
        child_ids.length
      end
      
      def all
        where({})
      end
    end
  end
end