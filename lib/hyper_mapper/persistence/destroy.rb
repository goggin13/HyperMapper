require 'active_support/inflector'

module HyperMapper
  module Persistence
  
    def destroy
      if self.class.embedded?
        children = self.class.name.underscore.pluralize
        parent.send(children).remove(key_value)
        to_rm = {}
        to_rm[children] = key_value
        HyperMapper::Config.client.map_remove parent.class.space_name, 
                                              parent.key_value,
                                              to_rm  
      else
        HyperMapper::Config.client.delete(self.class.space_name, key_value)
      end
    end
  end
end
