require 'json'

module HyperMapper
  module Document

    class EmbeddedCollection
      def initialize(options={})
        @klass = options[:class]
        @parent = options[:parent]
        @klass_plural = @klass.name.to_s.underscore

        children = options[:values] ? options[:values].value : nil

        @elements = {}
        if children.is_a? Hash
          initialize_from_json_map children
        elsif children.is_a? Array
          initialize_from_array children
        end
      end

      def initialize_from_array(arr)
        arr.each do |attrs|
          child = @klass.load_from_attrs attrs
          self.<< child
          child.persisted = false
        end
      end
      
      def initialize_from_json_map(map)
        map.each do |k, attrs|
          child = add_from_json k, attrs
          child.persisted = true 
        end
      end

      def [](v)
        @elements.to_a[v][1]
      end

      def find(id)
        @elements[id]
      end

      def remove(id)
        @elements.delete(id) if @elements.has_key?(id)
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
        (@elements || {}).each { |k,v| block.call(v) }
      end

      def to_json
        @elements.inject({}) do |acc, (_, child)|
          child_json = child.serializable_hash
          child_json.delete @klass.key_name
          acc[child.key_value.to_s] = child_json.to_json
          acc
        end
      end

      def all
        @elements.map { |k, child| child }
      end

      def add_from_json(k, json)
        child = from_json! json
        child.send("#{@klass.key_name}=", k)
        self.<< child
        child
      end

      def from_json!(json_map)
        instance = @klass.new
        JSON.load(json_map).each do |attr, val| 
          instance.send("#{attr}=", val)
        end
        instance
      end
      
      def create(attrs)
        create!(attrs)
      end

      def create!(attrs)
        child = @klass.load_from_attrs(attrs)
        child.parent = @parent
        child.save
        self.<< child
        child
      end

      def build(attrs={})
        child = @klass.new(attrs)
        self.<< child
        child
      end
    end
    
    def serializable_hash
      hash = attribute_values_map.inject({}) do |acc, (_, attr)|
        acc[attr.name] = attr.value.to_s
        acc
      end
     
      hash.delete parent_name
      
      hash
    end

    def to_json
      serializable_hash.to_json
    end

    module ClassMethods
      
      def embedded_classes
        @embedded_classes ||= []
      end

      def embeds_many(children, options={})
        
        attribute children

        child_class = children.to_s.classify.constantize
        
        define_method children do
          @embedded_collections ||= {}
          @embedded_collections[children] ||= 
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
