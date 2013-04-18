require 'active_support/inflector'

module HyperMapper
  module Persistence

    def update_attributes!(attrs={})
      update_attributes(attrs)
    end
    
    def update_attributes(attrs={})
      self.class.verify_attr_accessible! attrs
      attrs.each do |key, value|
        send("#{key}=", value)
      end
      save
    end
  end
end
 

