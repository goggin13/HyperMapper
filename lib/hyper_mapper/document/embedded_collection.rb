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
        @parent.save
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
        child = @klass.new(attrs)
        self.<< child
        child.save
        child
      end

      def build(attrs={})
        child = @klass.new(attrs)
        self.<< child
        child
      end
      
      def where
      end
    end
  end
end