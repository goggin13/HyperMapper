require 'json'

module HyperMapper
  module Document
    def ==(other)
      other.is_a?(self.class) && key_value == other.key_value
    end
  end
end
