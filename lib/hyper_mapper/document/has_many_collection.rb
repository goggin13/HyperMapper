module HyperMapper
  module Document
    class HasManyCollection
      include Enumerable
      attr_accessor :foreign_key

      def initialize(options={})
        @klass = options[:class]
        @parent = options[:parent]
        @foreign_key = @parent.class.foreign_key
      end

      def [](v)
        all[v]
      end
    
      def find(id)
        predicate = {}
        predicate[@klass.key_name.to_s] = id
        where(predicate)[0]
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
      
      def create(attrs)
        attrs[foreign_key] = @parent.key_value
        @klass.create attrs
      end      

      def build(attrs={})
        attrs[foreign_key] = @parent.key_value
        @klass.new attrs
      end

      def <<(child)
        child.send("#{@foreign_key}=", @parent.key_value)
        child.save
      end
      
      def where(predicate={})
        predicate[foreign_key] = @parent.key_value
        @klass.where predicate
      end
      
      def remove(item)
        item.send("#{@foreign_key}=", nil)
        item.save
        item
      end
      
      def length
        predicate = {}
        predicate[foreign_key] = @parent.key_value
        @klass.count predicate
      end
    end
  end
end