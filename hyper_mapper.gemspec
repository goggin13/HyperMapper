# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hyper_mapper/version'

Gem::Specification.new do |gem|
  gem.name          = "hyper_mapper"
  gem.version       = HyperMapper::VERSION
  gem.authors       = ["Matt Goggin"]
  gem.email         = ["goggin13@gmail.com"]
  gem.description   = %q{An ODM for HyperDex, a distributed key-value store}
  gem.summary       = %q{An ODM for HyperDex, a distributed key-value store}
  gem.homepage      = "http://hyperdex.org/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activerecord', '~> 3.2.11'
  gem.add_dependency 'activesupport', '~> 3.2.11'
  gem.add_dependency 'activemodel', '~> 3.2.11'
  gem.add_development_dependency 'rspec', '~> 2.12'
  gem.add_development_dependency 'pry', '~> 0.9.12'
  gem.add_development_dependency 'simplecov'
end
