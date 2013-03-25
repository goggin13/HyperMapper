require 'hyper_mapper/document/attribute' 
require 'hyper_mapper/document/embed' 
require 'hyper_mapper/document/has_many' 
require 'hyper_mapper/document/has_and_belongs_to_many' 
require 'hyper_mapper/document/timestamp' 
require 'hyper_mapper/finders'
require 'active_model'

module HyperMapper
  module Document
    def self.included(mod)
      mod.send(:extend, ClassMethods)
      mod.send(:extend, HyperMapper::Finders)

      mod.send(:extend, ActiveModel::Callbacks)
      mod.send(:define_model_callbacks, :save, :create)

      mod.send(:include, ActiveModel::Validations)
      mod.send(:include, HyperMapper::Persistence)
    end

    def initialize(params={})
      params.each do |key, val|
        self.send("#{key}=", val)
      end
    end
  end
end
