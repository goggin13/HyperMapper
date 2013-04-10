require 'active_support/inflector'

module HyperMapper
  module Persistence
    attr_accessor :persisted

    def save
      callbacks = persisted? ? [:save] : [:save, :create]
      run_callbacks :save do
        if persisted? 
          save_inner
        else
          run_callbacks :create do
            save_inner
          end
        end
      end
    end
    
    def save_inner
      if persisted? && attribute_values_map[self.class.key_name].dirty?
        raise Exceptions::IllegalKeyModification.new("Key #{self.class.key_name} cannot be modified")
      end

      if self.class.embedded?
        #f = self.model_name.underscore.pluralize
        #to_add = parent.send(f)
        #hash = serializable_hash
        #hash.delete self.class.key_name
        #to_add << self 
        #parent.send("#{f}=", to_add)
        #persisted = HyperMapper::Config.client.map_add parent.class.space_name,
        #                                                parent.key_value,
        #                                                to_add
        (self.persisted = parent.send(:persist)) if valid?
      else
        (self.persisted = persist) if valid?
      end

      @persisted
    end

    def persisted?
      @persisted.nil? ? false : @persisted
    end
    
    def persisted=(v)
      @persisted=v
      clean_attributes! if @persisted
    end

    private 
      
      def persist
        return false unless key_value
        attrs = attributes_for_save
        HyperMapper::Config.client.put(self.class.space_name, key_value, attrs)
      end
  end
end
