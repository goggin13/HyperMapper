require 'active_support/inflector'

module HyperMapper
  module Persistence
  
    def destroy
      if self.class.embedded?
        children = self.class.name.underscore.pluralize
        parent.send(children).remove(key_value)
      else
        HyperMapper::Config.client.delete(self.class.space_name, key_value)
      end
    end
  end
end
