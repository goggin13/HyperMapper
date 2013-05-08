require 'json'

module HyperMapper
  module Document
    class EmbeddedCollection
      include Enumerable
      
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
          @elements[child.key_value] = child
          child.parent = @parent
          child.persisted = false
        end
      end
      
      def initialize_from_json_map(map)
        map.each do |k, attrs|
          child = add_from_json k, attrs
          child.persisted = true
        end
      end

      def find(id)
        @elements[id.to_s]
      end

      def remove(item)
        @elements.delete(item.id) if @elements.has_key?(item.id)
        delete = {}
        delete[@klass.embedded_collection_name] = {}
        delete[@klass.embedded_collection_name][item.id] = "dummy"
        Config.client.map_remove @parent.class.space_name,
                                 @parent.key_value,
                                 delete
        item
      end
      
      def <<(item)
        
        @elements[item.key_value.to_s] = item
        item.parent = @parent
        item.save unless item.persisted?
        
        item
      end

      def length
        @elements.length
      end

      def each
        (@elements || {}).each { |k,v| yield(v) }
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
        child.persisted = true
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
        child = @klass.new(attrs)
        child.parent = @parent
        child.save
        self.<< child if child.valid?
        child
      end

      def create!(attrs)
        child = @klass.new(attrs)
        child.parent = @parent
        child.save!
        self.<< child
        child
      end

      def build(attrs={})
        child = @klass.new(attrs)
        @elements[child.key_value] = child
        child.parent = @parent
        child
      end
      
      def where(params={})
        msg = "where queries are not supported on embedded collections"
        raise Exceptions::NotSupportedException.new msg
      end
    end
  end
end