require 'hyper_mapper/persistence/insert'
require 'hyper_mapper/persistence/save'
require 'hyper_mapper/persistence/destroy'

module HyperMapper
  module Persistence
    def self.included(mod)
      mod.send(:extend, ClassMethods)
    end
  end
end
