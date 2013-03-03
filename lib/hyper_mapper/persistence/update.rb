require 'active_support/inflector'

module HyperMapper
  module Persistence

    def update_attributes(attrs={})
      attrs.each do |key, value|
        send("#{key}=", value)
      end
      save
    end
  end
end
 

