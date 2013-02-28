

module HyperMapper
  module Document
    module ClassMethods
      
      def key_name
        @key_name ? @key_name.to_sym : nil
      end

      def key_name=(v)
        @key_name = v
        validates_presence_of v
      end

      def attributes_map 
        @attributes_map ||= {}
      end
      
      def create_attribute(name, params)
        attributes_map[name] = Attribute.new(name, params)
      end
      
      def key(name, params={})
        attribute name, params.merge(key: true)
      end

      def attribute(name, params={})
        
        create_attribute(name, params) 
        
        if (params.has_key? :key) && params[:key]
          self.key_name = name
        end

        define_method "#{name}=" do |val|
          set_attribute_value name, val
        end

        define_method "#{name}" do
          get_attribute_value name
        end
      end
    end
    
    class Attribute
      def initialize(name, options={})
        @name = name
        @options = options
      end
    end

    class AttributeValue
      attr_accessor :name, :value
      def initialize(name, value)
        @name = name
        @value = value
      end
    end
    
    def attribute_values_map
      @attribute_values ||= {}
    end

    def attribute_values_map_raw
      attrs = attribute_values_map.inject({}) do |acc, (key, field)|
        acc[key] = (field ? field.value : nil)
        acc
      end
      
      self.class.embedded_classes.each do |children|
        child_attrs = self.send(children).to_a
        attrs[children] = child_attrs unless child_attrs.length == 0
      end

      attrs
    end
    
    def read_attribute_for_validation(key)
      attribute_values_map_raw[key]
    end

    def set_attribute_value(name, val)
      if attribute_values_map.has_key? name
        attribute_values_map[name].value = val
      else
        attribute_values_map[name] = AttributeValue.new(name, val)
      end
    end

    def get_attribute_value(name)
      (attribute_values_map.has_key? name) ? attribute_values_map[name].value : nil
    end
  end
end
