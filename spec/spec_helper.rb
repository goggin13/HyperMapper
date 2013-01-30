require 'rubygems'
require 'bundler/setup'

require 'hyper_mapper' 

MODELS = File.join(File.dirname(__FILE__), "app/models")
$LOAD_PATH.unshift(MODELS)

RSpec.configure do |config|
  config.mock_with :rspec
end
