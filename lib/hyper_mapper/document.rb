require 'hyper_mapper/document/attribute' 

module HyperMapper
  module Document
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:include, HyperMapper::Persistence)
    end
  end
end
