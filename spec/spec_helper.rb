require 'rubygems'
require 'bundler/setup'

require 'hyper_mapper' 

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

MODELS = File.join(File.dirname(__FILE__), 'app/models')
$LOAD_PATH.unshift(MODELS)

# Autoload every model for the test suite that sits in spec/app/models.
Dir[ File.join(MODELS, '*.rb') ].sort.each do |file|
  name = File.basename(file, '.rb')
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

def stub_put(space, key, attrs, ret=true)
  @client.should_receive(:put)
           .with(space, key, attrs)
           .and_return(ret)
end

def stub_get(space, key, ret)
  @client.should_receive(:get)
           .with(space, key)
           .and_return(ret)
end

def stub_any_put(space, ret=true)
  @client.should_receive(:put) do |s|
    space.should == s
  end.and_return(ret)
end

def stub_auto_id_put(space, attrs, ret=true)
  @client.should_receive(:put) do |s, id, args|
    id.length.should == 32
    space.should == s
    args.should == attrs
  end.and_return(ret)
end

def stub_search(space, predicate, result)
  @client.should_receive(:search)
         .with(space, predicate)
         .and_return(result)
end

def stub_map_remove(space, key, map, ret=true)
  @client.should_receive(:map_remove)
         .with(space, key, map)
         .and_return(ret)
end

def stub_map_add(space, key, map, ret=true)
  @client.should_receive(:map_add)
         .with(space, key, map)
         .and_return(ret)
end

def stub_map_add(space, key, map_key, map_value, ret=true)
  to_add = {}
  to_add[map_key] = map_value
  @client.should_receive(:map_add)
         .with(space, key, to_add)
         .and_return(ret)
end

def stub_auto_id_map_add(space, key, value, ret=true)
  @client.should_receive(:map_add) do |s, k, m|
     s.should == space
     k.should == key
     m.length.should == 1
     m.each do |id, val|
       id.length.should == 32
       val.should == value
     end
  end.and_return(ret)
end

