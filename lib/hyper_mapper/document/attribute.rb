

module HyperMapper
  module Document
    module ClassMethods
      
      def attributes_map 
        @attributes_map ||= {}
      end
      
      def create_attribute(name, params)
        attributes_map[name] = Attribute.new(name, params)
      end

      def attribute(name, params={})
        
        create_attribute(name, params) 

        define_method "#{name}=" do |val|
          set_attribute_value name, val
        end

        define_method "#{name}" do
          get_attribute_value name
        end
      end

      def key(params={})

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
