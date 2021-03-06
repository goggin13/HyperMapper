require 'rubygems'
require 'bundler/setup'
require 'simplecov'

SimpleCov.start if ENV['COVERAGE']
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

def stub_multi_get(space, keys, ret)
  @client.should_receive(:multi_get)
           .with(space, keys)
           .and_return(ret)
end

def stub_any_put(space, ret=true)
  @client.should_receive(:put) do |s|
    space.should == s
  end.and_return(ret)
end

def stub_auto_id_put(space, attrs, ret=true)
  auto_id = nil
  @client.should_receive(:put) do |s, id, args|
    id.length.should == 47
    auto_id = id
    space.should == s
    args.should == attrs
  end.and_return(ret)

  auto_id
end

def stub_search(space, predicate, result)
  @client.should_receive(:search)
         .with(space, predicate)
         .and_return(result)
end

def stub_count(space, predicate, result)
  @client.should_receive(:count)
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

def stub_delete(space, key, ret=true)
  @client.should_receive(:delete)
         .with(space, key)
         .and_return(ret)
end

def stub_auto_id_map_add(space, key, field, value, ret=true)
  @client.should_receive(:map_add) do |s, k, m|
     s.should == space
     k.should == key
     m.length.should == 1
     m[field].each do |id, val|
       id.length.should == 47
       val.should == value
     end
  end.and_return(ret)
end

def verify_collection_interface(klass)
  ['find',
   'where',
   'remove',
   '<<',
   'each',
   'length',
   'first',
   'all',
   'create',
   'create!',
   'build'].each do |method|
    klass.should respond_to method
  end
end
