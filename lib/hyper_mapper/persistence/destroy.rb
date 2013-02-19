require 'active_support/inflector'

module HyperMapper
  module Persistence
  
    def destroy
      HyperMapper::Config.client.delete(self.class.space_name, key_value)
    end
  end
end
