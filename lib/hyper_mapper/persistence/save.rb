require 'active_support/inflector'

module HyperMapper
  module Persistence

    def save
      run_callbacks :save do
        if self.class.embedded?
          @persisted = parent.save
        else
          (@persisted = persist) if valid?
        end

        @persisted
      end
    end

    def persisted?
      @persisted.nil? ? false : @persisted
    end

    private 
      
      def persist
        return false unless key_value
        attrs = attributes_for_save
        HyperMapper::Config.client.put(self.class.space_name, key_value, attrs)
      end
  end
end
 

