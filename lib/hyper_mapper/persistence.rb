require 'hyper_mapper/persistence/insert'

module HyperMapper
  module Persistence
    def self.included(mod)
      mod.send(:extend, ClassMethods)
    end
  end
end
