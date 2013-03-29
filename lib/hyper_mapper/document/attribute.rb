require 'securerandom'

module HyperMapper
  module Document
    module ClassMethods
      
      def key_name
        @key_name ? @key_name.to_sym : nil
      end
      
      def foreign_key
        "#{self.model_name.underscore}_#{key_name}"
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

      def autogenerate_id(name=:id, params={})
        attribute name, params.merge(key: true, autogenerate: true)
      end
      
      def attribute(name, params={})
        
        create_attribute(name, params) 
        
        if (params.has_key? :key) && params[:key]
          self.key_name = name
          if params[:autogenerate]
            before_save :set_autogenerated_key
          end
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

      def autogenerate?
        @options[:autogenerate]
      end

    end

    class AttributeValue
      attr_accessor :name, :value, :dirty

      def initialize(name, value, dirty=true)
        @name = name
        @value = value
        @dirty = dirty
      end
      
      def value=(v)
        @value = v
        @dirty = true
      end
    end
    
    def random_string
      SecureRandom.hex(16)
    end
    
    def set_autogenerated_key
      kattr = attribute_values_map[self.class.key_name]
      return if kattr && kattr.value
      
      unless kattr
        kattr = AttributeValue.new self.class.key_name, nil 
      end
      
      kattr.value = random_string
      attribute_values_map[self.class.key_name] = kattr
    end

    def key_value
      kattr = attribute_values_map[self.class.key_name]
      kattr ? kattr.value : nil
    end 

    def to_key
      [key_value]
    end
    
    def to_param
      key_value
    end

    def model_name
      self.class.name
    end    

    def attribute_values_map
      @attribute_values ||= {}
    end
    
    def clean_attributes!
      attribute_values_map.each do |k, v|
        v.dirty = false
      end
    end

    def attribute_values_map_raw
      attribute_values_map.inject({}) do |acc, (key, field)|
        acc[key] = (field ? field.value : nil)
        acc
      end
    end
    
    def attributes_for_save
      attrs = attribute_values_map.inject({}) do |acc, (key, field)|
        if field && field.dirty
          acc[key] = field.value
        end
        acc
      end

      self.class.embedded_classes.each do |children|
        if self.send(children).length > 0
          attrs[children] = self.send(children).to_json
        else
          attrs.delete children
        end
      end
      
      attrs.delete self.class.key_name

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
