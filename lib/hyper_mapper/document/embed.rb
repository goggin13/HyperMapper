require 'json'

module HyperMapper
  module Document

    class EmbeddedCollection
      def initialize(options={})
        @klass = options[:class]
        @parent = options[:parent]

        children_hash = options[:values] ? options[:values].value : "[]"
        children_hash ||= []
        if children_hash.is_a? String
          children_hash = JSON.load children_hash 
        end

        @elements = {}
        children_hash.each do |attrs|
          if attrs.is_a? String
            add_from_json attrs
          else
            child = @klass.load_from_attrs attrs
            self.<< child
          end
        end
      end

      def [](v)
        @elements.to_a[v][1]
      end

      def find(id)
        @elements[id]
      end

      def <<(item)
        @elements[item.key_value] = item
        item.parent = @parent
      end

      def length
        @elements.length
      end

      def first
        self[0]
      end

      def each(&block)
        @elements.each { |k,v| block.call(v) }
      end

      def to_a
        @elements.map do |k, child|
          child.to_json
        end.to_json
      end

      def add_from_json(json)
        self.<< from_json!(json)
      end

      def from_json!(string)
        instance = @klass.new
        JSON.load(string).each do |attr, val| 
          instance.send("#{attr}=", val)
        end
        instance
      end

      def create!(attrs)
        child = @klass.load_from_attrs(attrs)
        self.<< child
        child.save
      end
    end

    def to_json
      hash = attribute_values_map.inject({}) do |acc, (k, attr)|
        acc[attr.name] = attr.value.to_s
        acc
      end
     
      hash.delete parent_name

      hash.to_json
    end

    module ClassMethods
      
      def embedded_classes
        @embedded_classes ||= []
      end

      def embeds_many(children, options={})
        
        attribute children

        child_class = children.to_s.singularize.camelcase.constantize
        
        define_method children do
          @embedded ||= 
             EmbeddedCollection.new class: child_class,
                                    values: attribute_values_map[children],
                                    parent: self
        end
        
        embedded_classes << children
      end
      
      def embedded_in(parent, options={})
        @embedded = true
        
        attribute parent
        alias_method :parent, parent
        alias_method 'parent=', "#{parent}="

        define_method 'parent_name' do
          parent
        end
      end

      def embedded?
        @embedded ? @embedded : false  
      end
    end
  end
end
