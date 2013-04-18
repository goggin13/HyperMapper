require 'active_support/inflector'

module HyperMapper
  module Persistence
    attr_accessor :persisted

    def save
      success = true
      run_callbacks :save do
        success = valid?
        if success
          if persisted? 
            save_inner
          else
            run_callbacks :create do
              save_inner
            end
          end
        end
      end

      success ? self : false
    end
    
    def save_inner
      if persisted? && attribute_values_map[self.class.key_name].dirty?
        raise Exceptions::IllegalKeyModification.new("Key #{self.class.key_name} cannot be modified")
      end

      if self.class.embedded?
        embedded_collection_name = self.model_name.underscore.pluralize
        parent.send(embedded_collection_name) << self
        update = {}
        update[embedded_collection_name] = {}
        update[embedded_collection_name][self.key_value.to_s] = self.to_json
        persisted = HyperMapper::Config.client.map_add parent.class.space_name,
                                                       parent.key_value,
                                                       update
      else
        persist
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
        self.persisted = HyperMapper::Config.client.put(self.class.space_name, key_value, attrs)
      end
  end
end
