require 'hyper_mapper/document/attribute' 
require 'hyper_mapper/document/embed' 
require 'hyper_mapper/finders'
require 'active_model'

module HyperMapper
  module Document
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:extend, HyperMapper::Finders)
      mod.send(:include, HyperMapper::Persistence)
      mod.send(:include, ActiveModel::Validations)
    end

    def initialize(params={})
      params.each do |key, val|
        self.send("#{key}=", val)
      end
    end
  end
end
