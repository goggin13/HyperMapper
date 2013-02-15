require 'rubygems'
require 'bundler/setup'

require 'hyper_mapper' 

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

MODELS = File.join(File.dirname(__FILE__), "app/models")
$LOAD_PATH.unshift(MODELS)

# Autoload every model for the test suite that sits in spec/app/models.
Dir[ File.join(MODELS, "*.rb") ].sort.each do |file|
  name = File.basename(file, ".rb")
  class_name = name.gsub(/[^_]+/) do |word|
    word.capitalize
  end.gsub(/_/, '')
  autoload class_name, name
end

RSpec.configure do |config|
  config.mock_with :rspec
end

def stub_client
  client = double('client')
  HyperMapper::Config.client = client
end
