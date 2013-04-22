require 'active_support/inflector'

module HyperMapper
  module Persistence
  
    def destroy
      if self.class.embedded?
        children = self.class.embedded_collection_name
        parent.send(children).remove(self)
      else
        HyperMapper::Config.client.delete(self.class.space_name, key_value)
      end
    end
  end
end
