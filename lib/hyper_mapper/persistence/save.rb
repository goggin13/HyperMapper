require 'active_support/inflector'

module HyperMapper
  module Persistence
    attr_accessor :persisted

    def save
      run_callbacks :save do
        if self.class.embedded?
          to_add = {}
          hash = serializable_hash
          hash.delete self.class.key_name
          to_add[key_value] = hash.to_json
          @persisted = HyperMapper::Config.client.map_add parent.class.space_name,
                                                          parent.key_value,
                                                          to_add
        else
          (@persisted = persist) if valid?
        end

        @persisted
      end
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
 

